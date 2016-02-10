module Denshobato
  class Message < ::ActiveRecord::Base
    self.table_name = 'denshobato_messages'

    # Belongs to conversation
    belongs_to :denshobato_conversation, class_name: '::Denshobato::Conversation', inverse_of: :denshobato_messages

    # Validations
    validates :body, :conversation_id, :sender_id, presence: true

    # Alias
    alias conversation denshobato_conversation
  end
end
