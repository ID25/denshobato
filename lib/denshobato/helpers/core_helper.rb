module Denshobato
  module CoreHelper
    include Denshobato::HelperUtils
    def my_conversations
      # Return active user conversations (not in trash)

      trashed = block_given? ? yield : false
      hato_conversation.my_conversations(self, trashed)
    end

    def trashed_conversations
      # Return trashed conversations

      my_conversations { true } # => hato_conversation.where trashed: true
    end

    def make_conversation_with(recipient)
      # Build conversation.
      # = form_for current_user.make_conversation_with(recipient) do |f|
      # = f.submit 'Start Chat', class: 'btn btn-primary'

      hato_conversations.build(recipient: recipient)
    end

    def find_conversation_with(user)
      # Return an existing conversation with sender and recipient

      hato_conversation.find_by(sender: self, recipient: user)
    end

    def send_message(text, recipient)
      # This method send message to recipient directly
      # Takes responsibility to create conversation, if it not exist yet
      # or send message to existing conversation

      # Find conversation.
      room = hato_conversation.find_by(sender: self, recipient: recipient)

      # If conversation not exist, create one.
      conversation = room.nil? ? create_conversation(self, recipient) : room

      # Return validation error, if conversation is a String (see create_conversation method)
      return errors.add(:blacklist, conversation) if conversation.is_a?(String)

      # Create message for this conversation.
      send_message_to(conversation.id, body: text)
    end

    def send_message_to(id, params)
      # This method send message to conversation directly

      return errors.add(:message, 'Conversation not present') unless id

      # Expect record id
      # If id == active record object, get their id
      id = id.id if id.is_a?(ActiveRecord::Base)

      room = hato_conversation.find(id)

      # Show validation error, if author of message not in conversation
      return message_error(id, self) unless user_in_conversation(room, self)

      # If everything is ok, build message
      hato_messages.build(params)
    end

    def add_to_blacklist(user)
      # Add user to blacklist
      # User can`t create conversation, and can`t send message to blocker model

      blacklist.build(blocked: user)
    end

    def remove_from_blacklist(user)
      # Removeu user from blacklist

      hato_blacklist.find_by(blocker: self, blocked: user)
    end

    # Default methods only for built-in Chat Panel
    def full_name
      # Set up default name for chat panel
      # By default it be a class name, e.g => User

      self.class.name.titleize
    end

    def image
      # Set up default avatar in chat panel
      # TODO: Generate random image e.g first letter on name, or email

      'http://i.imgur.com/pGHOaLg.png'
    end

    private

    def create_conversation(sender, recipient)
      room = sender.make_conversation_with(recipient)

      # Get validation error
      room.valid? ? room.save && room : room.errors[:blacklist].join('')
    end

    def message_error(id, author)
      # TODO: Return validation error with most efficient way

      author.hato_messages.build(conversation_id: id)
    end

    def user_in_conversation(room, author)
      # Check if user in conversation, as sender or recipient

      hato_conversation.where(id: room.id, sender: author).present? || hato_conversation.where(id: room.id, recipient: author).present?
    end
  end
end
