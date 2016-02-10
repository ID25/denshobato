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
  end
end
