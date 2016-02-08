class CreateDenshobatoConversations < ActiveRecord::Migration
  def change
    create_table :denshobato_conversations do |t|
      t.integer :sender_id,    index: true
      t.integer :recipient_id, index: true

      t.timestamps
    end
    add_index :denshobato_conversation, [:sender_id, :recipient_id], unique: true
  end
end
