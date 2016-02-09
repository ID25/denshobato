module Denshobato
  module SenderHelper
    # Fetch conversations for current_user/admin/duck/customer/whatever model.
    def my_conversations
      Denshobato::Conversation.conversations_for(self)
    end
  end
end
