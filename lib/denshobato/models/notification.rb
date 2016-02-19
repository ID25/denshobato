module Denshobato
  class Notification < ::ActiveRecord::Base
    self.table_name = 'denshobato_notifications'

    belongs_to :denshobato_message
    belongs_to :denshobato_conversation
  end
end
