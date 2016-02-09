$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'database_cleaner'
require 'active_record'
require 'denshobato'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define(version: 1) do
  create_table :users do |t|
    t.string :name, default: ''
  end

  create_table :admins do |t|
    t.string :name, default: ''
  end

  create_table :ducks do |t|
    t.string :name, default: ''
  end

  create_table :denshobato_conversations do |t|
    t.integer  'sender_id'
    t.integer  'recipient_id'
    t.string   'sender_class',    default: ''
    t.string   'recipient_class', default: ''
  end

  create_table :denshobato_messages do |t|
    t.integer :conversation_id, index: true
    t.integer :sender_id,       index: true
    t.text    :body, default: ''
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
