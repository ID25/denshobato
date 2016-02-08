$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'active_record'
require 'denshobato'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define(version: 1) do
  create_table :users do |t|
    t.string :name, default: ''

    t.timestamps
  end

  create_table :denshobato_conversations do |t|
    t.integer  'sender_id'
    t.integer  'recipient_id'

    t.timestamps
  end
end
