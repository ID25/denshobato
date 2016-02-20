module Denshobato
  module CoreHelper
    include Denshobato::HelperUtils

    def my_conversations
      # Fetch conversations for current_user/admin/duck/customer/whatever model.

      conversation.conversations_for(self)
    end

    def make_conversation_with(recipient)
      # Build conversation.
      # = form_for current_user.make_conversation_with(recipient) do |f|
      # = f.submit 'Start Chat', class: 'btn btn-primary'

      conversations.build(sender_class: class_name(self), recipient_id: recipient.id, recipient_class: class_name(recipient))
    end

    def find_conversation_with(user)
      # Return an existing conversation with sender and recipient

      finder = conversation_finder.new(user, self)
      finder.find_by_sender || finder.find_by_recipient
    end

    def send_message(text, recipient)
      # Find conversation.
      finder             = conversation_finder.new(self, recipient)
      conversation_class = finder.find_by_sender || finder.find_by_recipient

      # If conversation not exist, create one.
      conversation_class.nil? ? create_conversation(self, recipient) : conversation_class
      take_conversation = find_conversation_with(recipient)

      # Create message for this conversation.
      take_conversation.messages.create(body: text, sender_class: class_name(self), sender_id: id)
    end

    def send_message_to(id, params)
      room = conversation.find(id)

      # Show validation error, if author of message not in conversation

      return message_error(id, self) unless conversation.where(id: room.id, sender: self).present? || conversation.where(id: room.id, recipient: self).present?

      messages.build(params)
    end

    def build_conversation_message(conversation)
      messages.build(conversation_id: conversation.id, sender_id: id, sender_class: class_name(self))
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
  end
end
