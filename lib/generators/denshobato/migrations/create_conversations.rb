class CreateDenshobatoConversations < ActiveRecord::Migration
  def change
    create_table :denshobato_conversations do |t|
      t.integer :sender_id,       index: true
      t.integer :recipient_id,    index: true
      t.string  :sender_class,    default: ''
      t.string  :recipient_class, default: ''

      t.timestamps
    end
  end
end
