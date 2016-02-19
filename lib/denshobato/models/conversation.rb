module Denshobato
  class Conversation < ::ActiveRecord::Base
    self.table_name = 'denshobato_conversations'

    # Set-up Polymorphic association
    belongs_to :sender,    polymorphic: true
    belongs_to :recipient, polymorphic: true

    # Validate fields
    validates         :sender_id, :sender_type, :recipient_id, :recipient_type, presence: true
    validate          :conversation_uniqueness, on: :create
    before_validation :check_sender # sender can't create conversations with yourself.

    # Callbacks
    after_create      :recipient_conversation # Create conversation for recipient, where he is sender.

    private

    def recipient_conversation
      recipient.conversations.first_or_create(recipient_id: sender.id, recipient_type: sender.class.name)
    end

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
