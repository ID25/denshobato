class CreateDenshobatoNotifications < ActiveRecord::Migration
  def change
    create_table :denshobato_notifications do |t|
      t.integer :message_id,      index: { name: 'notification_for_message' }
      t.integer :conversation_id, index: { name: 'notification_for_conversation' }
    end

    add_index :denshobato_notifications, [:message_id, :conversation_id], name: 'unique_messages_for_conversations', unique: true
  end
end
