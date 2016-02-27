class CreateDenshobatoBlacklists < ActiveRecord::Migration
  def change
    create_table :denshobato_blacklists do |t|
      t.references :blocker, polymorphic: true, index: { name: 'blocker_user' }
      t.references :blocked, polymorphic: true, index: { name: 'blocked_user' }
    end
  end
end
