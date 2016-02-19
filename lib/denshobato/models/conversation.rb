module Denshobato
  class Conversation < ::ActiveRecord::Base
    self.table_name = 'denshobato_conversations'

    # Set-up Polymorphic association
    belongs_to :sender,    polymorphic: true
    belongs_to :recipient, polymorphic: true

    # Has many messages
    has_many :denshobato_messages, class_name: '::Denshobato::Message', dependent: :destroy, inverse_of: :denshobato_conversation

    # Validate fields
    validates         :sender_id, :sender_type, :recipient_id, :recipient_type, presence: true
    validate          :conversation_uniqueness, on: :create
    before_validation :check_sender # sender can't create conversations with yourself.

    # Fetch conversations for current_user/admin/duck/customer/whatever model.
    scope :conversations_for, -> (user) { where('sender_id = ? AND sender_class = ? or recipient_id = ? AND recipient_class = ?', user, user.class.name, user, user.class.name).order(updated_at: :desc) }

    # List all messages of conversation
    def show_messages(type)
      messages.order("denshobato_messages.created_at #{type.to_s.upcase}")
    end

    alias messages denshobato_messages

    private

    def check_sender
      errors.add(:conversation, 'You can`t create conversation with yourself') if sender == recipient
    end

    def conversation_uniqueness
      # Checking conversation for uniqueness, when recipient is sender, and vice versa.

      hash = Hash[*columns.flatten]
      if Conversation.where(hash).present?
        errors.add(:conversation, 'You already have conversation with this user.')
      end
    end

    def columns
      [['sender_id', sender_id], ['sender_type', sender_type], ['recipient_id', recipient_id], ['recipient_type', recipient_type]]
    end
  end
end
