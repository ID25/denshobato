module Denshobato
  module HelperUtils
    private

    def class_name(klass)
      klass.class.name
    end

    def hato_conversation
      Denshobato::Conversation
    end

    def hato_message
      Denshobato::Message
    end

    def hato_blacklist
      Denshobato::Blacklist
    end
  end
end
