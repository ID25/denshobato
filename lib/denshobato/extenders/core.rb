module Denshobato
  module Extenders
    module Core
      def denshobato_for(_klass)
        # Adds associations and methods to messagable model.

        adds_methods_to_model
      end

      private

      def adds_methods_to_model
        include Denshobato::CoreHelper # Adds helper methods for core model

        # Adds has_many association for a model, to allow it create conversations.
        class_eval do
          # Add conversations
          has_many :denshobato_conversations, as: :sender, class_name: '::Denshobato::Conversation', dependent: :destroy

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
