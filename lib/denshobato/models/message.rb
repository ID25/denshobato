module Denshobato
  class Message < ::ActiveRecord::Base
    self.table_name = 'denshobato_messages'

    # Validations
    validates :body, presence: true
  end
end
