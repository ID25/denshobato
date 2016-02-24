module Denshobato
  class Notification < ::ActiveRecord::Base
    self.table_name = 'denshobato_notifications'

    # Associations
    belongs_to :denshobato_message,      class_name: 'Denshobato::Message', foreign_key: 'message_id', dependent: :destroy
    belongs_to :denshobato_conversation, class_name: 'Denshobato::Conversation', foreign_key: 'conversation_id'

    # Validations
    validates :message_id, :conversation_id, presence: true
    validates :message_id, uniqueness: { scope: :conversation_id }

    # Aliases
    alias message denshobato_message
    alias conversation denshobato_conversation
  end
end
