module Denshobato
  module DenshobatoHelper
    def my_conversations
      # Fetch conversations for current_user/admin/duck/customer/whatever model.

      Denshobato::Conversation.conversations_for(self)
    end

    def make_conversation_with(recipient)
      # Build conversation.
      # = form_for current_user.make_conversation_with(recipient) do |f|
      # = f.submit 'Start Chat', class: 'btn btn-primary'

      conversations.build(sender_class: self.class.name, recipient_id: recipient.id, recipient_class: recipient.class.name)
    end
  end
end
