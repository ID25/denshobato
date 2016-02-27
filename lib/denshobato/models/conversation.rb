module Denshobato
  class Conversation < ::ActiveRecord::Base
    include Denshobato::HelperUtils

    self.table_name = 'denshobato_conversations'

    # Set-up Polymorphic association
    belongs_to :sender,    polymorphic: true
    belongs_to :recipient, polymorphic: true

    # Has Many association
    has_many :denshobato_notifications, class_name: '::Denshobato::Notification', dependent: :destroy

    # Validate fields
    validates         :sender_id, :sender_type, :recipient_id, :recipient_type, presence: true
    validate          :conversation_uniqueness, on: :create
    before_validation :check_sender # Sender can't create conversations with yourself.
    before_validation :blocked_user # Check if blocked user try to start conversation

    # Callbacks
    after_create      :recipient_conversation # Create conversation for recipient, where he is sender.
    after_destroy     :remove_messages, if: :both_conversation_removed? # Remove messages and notifications

    # Scopes
    scope :my_conversations, ->(user, bool) { includes(:recipient).where(trashed: bool, sender: user) }

    # Methods
    def messages
      # Return all messages for conversation

      ids = notifications.pluck(:message_id)
      hato_message.includes(:author).where(id: ids)
    end

    def to_trash
      # Move conversation to trash

      bool = block_given? ? yield : true
      update(trashed: bool)
    end

    def from_trash
      # Move conversation from trash, to active

      to_trash { false }
    end

    # Alias
    alias notifications denshobato_notifications

    private

    def recipient_conversation
      if hato_conversation.where(recipient: sender, sender: recipient).present?
        errors.add(:conversation, 'You already have conversation with this user')
      else
        recipient.make_conversation_with(sender).save
      end
    end

    def check_sender
      errors.add(:conversation, 'You can`t create conversation with yourself') if sender == recipient
    end

    def conversation_uniqueness
      # Checking conversation for uniqueness, when recipient is sender, and vice versa.

      hash = Hash[*columns.flatten] # => { sender_id: 1, sender_type: 'User' ... }

      errors.add(:conversation, 'You already have conversation with this user.') if hato_conversation.where(hash).present?
    end

    def remove_messages
      # When sender and recipient remove their conversation together
      # remove all messages belongs to this conversation and notifications

      hato_message.where(id: messages.map(&:id)).destroy_all
      notifications.destroy_all
    end

    def both_conversation_removed?
      # Check when both conversations removed

      hato_conversation.where(sender: recipient, recipient: sender).empty?
    end

    def blocked_user
      if hato_blacklist.where(blocker: recipient, blocked: sender).present?
        errors.add(:blacklist, 'You`re in blacklist')
      end

      if hato_blacklist.where(blocker: sender, blocked: recipient).present?
        errors.add(:blacklist, 'Remove user from blacklist, to start conversation')
      end
    end

    def columns
      [['sender_id', sender_id], ['sender_type', sender_type], ['recipient_id', recipient_id], ['recipient_type', recipient_type]]
    end
  end
end
