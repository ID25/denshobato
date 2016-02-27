module Denshobato
  module ConversationHelper
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
  end
end
