module Denshobato
  module HelperUtils
    private

    def conversation
      Denshobato::Conversation
    end

    def class_name(klass)
      klass.class.name
    end

    def conversation_finder
      Denshobato::ConversationFinder
    end
  end
end
