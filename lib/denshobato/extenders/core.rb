module Denshobato
  module Extenders
    module Core
      def denshobato_for(klass)
        adds_methods_to_model

        # Adds belongs_to association for a model.
        # Parameter must be singularize.

        # Example: denshobato_for :user
        Denshobato::Conversation.class_eval do
          belongs_to klass, class_name: klass.to_s.classify, foreign_key: 'sender_id'
        end
      end

      private

      def adds_methods_to_model
        # Adds has_many association for a model, to allow it create conversations.
        class_eval do
          has_many :denshobato_conversations, class_name: '::Denshobato::Conversation', foreign_key: 'sender_id'
        end
      end
    end
  end
end
