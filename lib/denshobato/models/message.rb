module Denshobato
  class Message < ::ActiveRecord::Base
    attr_accessor :conversation_id

    self.table_name = 'denshobato_messages'

    # Associations
    belongs_to :author, polymorphic: true
    has_many   :denshobato_notifications, class_name: '::Denshobato::Notification'

    # Validations
    before_validation :access_to_posting_message
    validates         :body, :author_id, :author_type, presence: true

    # Callbacks
    before_destroy :skip_deleting_messages, if: :message_belongs_to_conversation?

    # Alias
    alias notifications denshobato_notifications

    # Methods
    def send_notification(id)
      # Find current conversation
      conversation = hato_conversation.find(id)

      # Create Notifications
      create_notifications_for(conversation)
    end

    def message_time
      # Formatted time for chat panel

      created_at.strftime('%a %b %d | %I:%M %p')
    end

    private

    def skip_deleting_messages
      errors.add(:base, 'Can`t delete message, as long as it belongs to the conversation')

      # The before_destroy callback needs a true/false value to determine whether or not to proceeed
      false
    end

    def access_to_posting_message
      return unless conversation_id

      room = hato_conversation.find(conversation_id)

      # If author of message is not present in conversation, show error

      errors.add(:message, 'You can`t post to this conversation') unless user_in_conversation(room, author)
    end

    def create_notifications_for(conversation)
      # Take sender and recipient
      sender         = conversation.sender
      recipient      = conversation.recipient

      # Find conversation where sender it's recipient
      conversation_2 = recipient.find_conversation_with(sender)

      # If recipient deletes conversation, create it for him
      conversation_2 = create_conversation_for_recipient(sender, recipient) if conversation_2.nil?

      # Send notifications for new messages to sender and recipient
      [conversation.id, conversation_2.id].each { |id| notifications.create(conversation_id: id) }
    end

    def user_in_conversation(room, author)
      # Check if user is already in conversation

      hato_conversation.where(id: room.id, sender: author).present? || hato_conversation.where(id: room.id, recipient: author).present?
    end

    def create_conversation_for_recipient(sender, recipient)
      # Create Conversation for recipient
      # Skip callbacks, because conversation for sender exists already

      conv = hato_conversation.new(sender: recipient, recipient: sender)
      hato_conversation.skip_callback(:create, :after, :recipient_conversation)
      conv.save
      conv
    end

    def message_belongs_to_conversation?
      # Check if message has live notifications for any conversation

      hato_conversation.where(id: notifications.pluck(:conversation_id)).present?
    end

    def hato_conversation
      Denshobato::Conversation
    end
  end
end
