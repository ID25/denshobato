class CreateDenshobatoConversations < ActiveRecord::Migration
  def change
    create_table :denshobato_conversations do |t|
      t.integer :sender_id,    index: true
      t.integer :recipient_id, index: true

      add_index :denshobato_conversation, [:sender_id, :recipient_id], unique: true
      t.timestamps
    end
  end
end
