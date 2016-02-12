class CreateDenshobatoMessages < ActiveRecord::Migration
  def change
    create_table :denshobato_messages do |t|
      t.integer :conversation_id, index: true
      t.integer :sender_id,                  index: true
      t.string  :sender_class,               default: ''
      t.text    :body,                       default: ''

      t.timestamps
    end
  end
end
