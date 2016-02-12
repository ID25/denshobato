module Denshobato
  class Message < ::ActiveRecord::Base
    self.table_name = 'denshobato_messages'

    # Belongs to conversation
    belongs_to :denshobato_conversation, class_name: '::Denshobato::Conversation', inverse_of: :denshobato_messages, foreign_key: 'conversation_id', touch: true

    # Validations
    validates :body, :conversation_id, :sender_id, :sender_class, presence: true

    # Alias
    alias conversation denshobato_conversation

    # Methods

    def sender
      sender_class.constantize.find(sender_id)
    end
  end
end
