module Denshobato
  class Message < ::ActiveRecord::Base
    attr_accessor :conversation_id

    self.table_name = 'denshobato_messages'

    belongs_to :author, polymorphic: true
    has_many   :denshobato_notifications, class_name: '::Denshobato::Notification', dependent: :destroy

    # Validations
    before_validation :access_to_posting_message
    validates         :body, :author_id, :author_type, presence: true

    # Alias
    alias notifications denshobato_notifications
    alias sender author

    # Methods
    def send_notification(id)
      # Find current conversation
      conversation = Denshobato::Conversation.find(id)

      # Create Notifications
      create_notifications_for(conversation)
    end

    private

    def access_to_posting_message
      return unless conversation_id

      conversation = Denshobato::Conversation
      room = conversation.find(conversation_id)

      # If author of message not present in conversation, show error

      unless conversation.where(id: room.id, sender: author).present? || conversation.where(id: room.id, recipient: author).present?
        errors.add(:message, 'You can`t post to this conversation')
      end
    end

    def create_notifications_for(conversation)
      # Take sender and recipient
      sender         = conversation.sender
      recipient      = conversation.recipient

      # Find conversation, where sender it's recipient
      conversation_2 = Denshobato::Conversation.find_by(sender: recipient, recipient: sender)

      # Send notifications for them
      notifications.create(conversation_id: conversation.id)
      notifications.create(conversation_id: conversation_2.id)
    end
  end
end
