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
      conversation = densh_conversation.find(id)

      # Create Notifications
      create_notifications_for(conversation)
    end

    private

    def access_to_posting_message
      return unless conversation_id

      room = densh_conversation.find(conversation_id)

      # If author of message not present in conversation, show error

      errors.add(:message, 'You can`t post to this conversation') unless user_in_conversation(room, author)
    end

    def create_notifications_for(conversation)
      # Take sender and recipient
      sender         = conversation.sender
      recipient      = conversation.recipient

      # Find conversation, where sender it's recipient
      conversation_2 = densh_conversation.find_by(sender: recipient, recipient: sender)

      # Send notifications for new messages to sender and recipient
      [conversation.id, conversation_2.id].each { |id| notifications.create(conversation_id: id) }
    end

    def densh_conversation
      Denshobato::Conversation
    end

    def user_in_conversation(room, author)
      conversation.where(id: room.id, sender: author).present? || conversation.where(id: room.id, recipient: author).present?
    end
  end
end
