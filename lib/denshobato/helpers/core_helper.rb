module Denshobato
  module CoreHelper
    include Denshobato::HelperUtils
    def my_conversations
      # Return active user conversations (not in trash)

      trashed = block_given? ? yield : false
      conversation.my_conversations(self, trashed)
    end

    def trashed_conversations
      # Return trashed conversations

      my_conversations { true }
    end

    def make_conversation_with(recipient)
      # Build conversation.
      # = form_for current_user.make_conversation_with(recipient) do |f|
      # = f.submit 'Start Chat', class: 'btn btn-primary'

      conversations.build(recipient: recipient)
    end

    def find_conversation_with(user)
      # Return an existing conversation with sender and recipient

      conversation.find_by(sender: self, recipient: user)
    end

    def send_message(text, recipient)
      # Find conversation.
      room = conversation.find_by(sender: self, recipient: recipient)

      # If conversation not exist, create one.
      room.nil? ? create_conversation(self, recipient) : room
      take_conversation = find_conversation_with(recipient)

      # Create message for this conversation.
      send_message_to(take_conversation.id, body: text)
    end

    def send_message_to(id, params)
      return errors.add(:message, 'Conversation not present') unless id

      # Expect record id
      # If id == active record object, get their id
      id = id.id if id.is_a?(ActiveRecord::Base)

      room = conversation.find(id)

      # Show validation error, if author of message not in conversation

      return message_error(id, self) unless user_in_conversation(room, self)

      messages.build(params)
    end

    # Default methods only for built-in Chat Panel
    def full_name
      self.class.name.titleize
    end

    def image
      'http://i.imgur.com/pGHOaLg.png'
    end

    private

    def create_conversation(sender, recipient)
      sender.make_conversation_with(recipient).save
    end

    def message_error(id, author)
      author.messages.build(conversation_id: id)
    end

    def user_in_conversation(room, author)
      conversation.where(id: room.id, sender: author).present? || conversation.where(id: room.id, recipient: author).present?
    end
  end
end
