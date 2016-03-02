module Denshobato
  module Extenders
    module Core
      def denshobato_for(_klass)
        # Adds associations and methods to messagable model

        adds_methods_to_model
      end

      private

      def adds_methods_to_model
        include Denshobato::CoreHelper # Adds helper methods for the core model

        # Adds has_many association for a model, to allow it to create conversations
        class_eval do
          # Add conversations
          has_many :denshobato_conversations, as: :sender, class_name: '::Denshobato::Conversation', dependent: :destroy

          # Add messages
          has_many :denshobato_messages, as: :author, class_name: '::Denshobato::Message', dependent: :destroy

          # Add blacklists
          has_many :denshobato_blacklists, as: :blocker, class_name: '::Denshobato::Blacklist', dependent: :destroy

          # Added alias for the sake of brevity
          alias_method :hato_conversations, :denshobato_conversations
          alias_method :hato_messages,      :denshobato_messages
          alias_method :blacklist,          :denshobato_blacklists
        end
      end
    end
  end
end
