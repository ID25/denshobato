module Denshobato
  class Notification < ::ActiveRecord::Base
    self.table_name = 'denshobato_notifications'

    belongs_to :denshobato_message,      class_name: 'Denshobato::Message', foreign_key: 'message_id'
    belongs_to :denshobato_conversation, class_name: 'Denshobato::Conversation', foreign_key: 'conversation_id'

    validates :message_id, :conversation_id, presence: true

    alias message denshobato_message
    alias conversation denshobato_conversation
  end
end
