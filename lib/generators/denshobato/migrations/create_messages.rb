class CreateDenshobatoMessages < ActiveRecord::Migration
  def change
    create_table :denshobato_messages do |t|
      t.text :body, default: ''
      t.references :author, polymorphic: true, index: { name: 'message_polymorphic_author' }

      t.timestamps null: false
    end
  end
end
