module Denshobato
  class Blacklist < ::ActiveRecord::Base
    self.table_name = 'denshobato_blacklists'

    # Set up polymorphic association
    belongs_to :blocker, polymorphic: true
    belongs_to :blocked, polymorphic: true

    # Validation
    validates :blocker_id, :blocker_type, uniqueness: { scope: [:blocked_id, :blocked_type], message: 'User already in your blacklist' }
    validates :blocked_id, :blocked_type, :blocker_id, :blocker_type, presence: true
  end
end
