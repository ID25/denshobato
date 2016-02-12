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

        Denshobato::Message.class_eval do
          belongs_to klass, class_name: klass.to_s.classify, foreign_key: 'sender_id'
        end
      end

      private

      def adds_methods_to_model
        include Denshobato::CoreHelper # Adds helper methods for core model

        # Adds has_many association for a model, to allow it create conversations.
        class_eval do
          # Add conversations
          has_many :denshobato_conversations, class_name: '::Denshobato::Conversation', foreign_key: 'sender_id', dependent: :destroy

          # Add messages
          has_many :denshobato_messages, class_name: '::Denshobato::Message', foreign_key: 'sender_id', dependent: :destroy

          # Added alias for the sake of brevity.
          alias_method :conversations, :denshobato_conversations
          alias_method :messages,      :denshobato_messages
        end
      end
    end
  end
end
