module Denshobato
  module MessageHelper
    def send_message(text, recipient)
      # This method sends message directly to the recipient
      # Takes responsibility to create conversation if it doesn`t exist yet
      # sends message to an existing conversation

      # Find conversation.
      room = hato_conversation.find_by(sender: self, recipient: recipient)

      # If conversation doesn`t exist, create one.
      conversation = room.nil? ? create_conversation(self, recipient) : room

      # Return validation error, if conversation is a String (see create_conversation method)
      return errors.add(:blacklist, conversation) if conversation.is_a?(String)

      # Create message for this conversation.
      send_message_to(conversation.id, body: text)
    end

    def send_message_to(id, params)
      # This method sends message directly to conversation

      return errors.add(:message, 'Conversation not present') unless id

      # Expect record id
      # If id == active record object, get it`s id
      id = id.id if id.is_a?(ActiveRecord::Base)

      room = hato_conversation.find(id)

      # Show validation error if the author of a message is not in conversation
      return message_error(id, self) unless user_in_conversation(room, self)

      # If everything is ok, build message
      hato_messages.build(params)
    end

    private

    def create_conversation(sender, recipient)
      room = sender.make_conversation_with(recipient)

      # Get validation error
      room.valid? ? room.save && room : room.errors[:blacklist].join('')
    end

    def message_error(id, author)
      # TODO: Return validation error in the most efficient way

      author.hato_messages.build(conversation_id: id)
    end

    def user_in_conversation(room, author)
      # Check if user is in conversation as sender or recipient

      hato_conversation.where(id: room.id, sender: author).present? || hato_conversation.where(id: room.id, recipient: author).present?
    end
  end
end
