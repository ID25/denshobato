module Denshobato
  module MessageHelper
    include Denshobato::HelperUtils

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

    private

    def create_conversation(sender, recipient)
      sender.make_conversation_with(recipient).save
    end
  end
end
