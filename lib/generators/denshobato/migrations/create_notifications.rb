class CreateDenshobatoNotifications < ActiveRecord::Migration
  def change
    create_table :denshobato_notifications do |t|
      t.integer :message_id,      index: { name: 'notification_for_message' }
      t.integer :conversation_id, index: { name: 'notification_for_conversation' }
    end
  end
end
