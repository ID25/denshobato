module Denshobato
  class Conversation < ::ActiveRecord::Base
    self.table_name = 'denshobato_conversations'

    # Set-up Polymorphic association
    belongs_to :sender,    polymorphic: true
    belongs_to :recipient, polymorphic: true

    # Has Many association
    has_many :denshobato_notifications, class_name: '::Denshobato::Notification', dependent: :destroy

    # Validate fields
    validates         :sender_id, :sender_type, :recipient_id, :recipient_type, presence: true
    validate          :conversation_uniqueness, on: :create
    before_validation :check_sender # sender can't create conversations with yourself.

    # Callbacks
    after_create      :recipient_conversation # Create conversation for recipient, where he is sender.

    # Methods
    def messages
      # Return all messages for conversation

      ids = notifications.pluck(:message_id)
      Denshobato::Message.find(ids)
    end

    # Alias
    alias notifications denshobato_notifications

    private

    def recipient_conversation
      if Denshobato::Conversation.where(recipient: sender, sender: recipient).present?
        errors.add(:conversation, 'You already have conversation with this user')
      else
        recipient.conversations.create(recipient: sender)
      end
    end

    def check_sender
      errors.add(:conversation, 'You can`t create conversation with yourself') if sender == recipient
    end

    def conversation_uniqueness
      # Checking conversation for uniqueness, when recipient is sender, and vice versa.

      hash = Hash[*columns.flatten]
      if Denshobato::Conversation.where(hash).present?
        errors.add(:conversation, 'You already have conversation with this user.')
      end
    end

    def columns
      [['sender_id', sender_id], ['sender_type', sender_type], ['recipient_id', recipient_id], ['recipient_type', recipient_type]]
    end
  end
end
