module Denshobato
  module SenderHelper
    def my_conversations
      # Fetch conversations for current_user/admin/duck/customer/whatever model.

      Denshobato::Conversation.conversations_for(self)
    end

    def make_conversation_with
      # Build conversation.
      # current_user.make_conversation_with do |f| ...

      conversations.build(sender_class: self.class.name)
    end
  end
end
