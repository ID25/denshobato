module Denshobato
  class Message < ::ActiveRecord::Base
    self.table_name = 'denshobato_messages'

    # Belongs to conversation
    belongs_to :conversation, class_name: '::Denshobato::Conversation'

    # Validations
    validates :body, :conversation_id, :sender_id, presence: true
  end
end
