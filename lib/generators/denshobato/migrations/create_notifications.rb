class CreateDenshobatoNotifications < ActiveRecord::Migration
  def change
    create_table :denshobato_notifications do |t|
      t.references :denshobato_message, foreign_key: true, index: { name: 'notification_for_message' }
      t.references :denshobato_conversation, foreign_key: true, index: { name: 'notification_for_conversation' }

      t.timestamps null: false
    end
  end
end
