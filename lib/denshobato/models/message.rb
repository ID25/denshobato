module Denshobato
  class Message < ::ActiveRecord::Base
    self.table_name = 'denshobato_messages'

    has_many :denshobato_notifications, class_name: '::Denshobato::Notification', dependent: :destroy

    # Validations
    validates :body, presence: true

    # Alias
    alias notifications denshobato_notifications
  end
end
