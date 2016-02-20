$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'database_cleaner'
require 'factory_girl'
require 'active_record'
require 'denshobato'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define(version: 1) do
  create_table :users do |t|
    t.string :name,      default: ''
    t.string :avatar,    default: ''
    t.string :last_name, default: ''
  end

  create_table :admins do |t|
    t.string :name, default: ''
  end

  create_table :ducks do |t|
    t.string :name,      default: ''
    t.string :last_name, default: ''
    t.string :avatar, default: ''
  end

  create_table :denshobato_conversations do |t|
    t.references :sender,    polymorphic: true, index: { name: 'conversation_polymorphic_sender' }
    t.references :recipient, polymorphic: true, index: { name: 'conversation_polymorphic_recipient' }

    t.timestamps null: false
  end

  create_table :denshobato_messages do |t|
    t.text :body, default: ''
    t.references :author, polymorphic: true, index: { name: 'message_polymorphic_author' }

    t.timestamps null: false
  end

  create_table :denshobato_notifications do |t|
    t.integer  :message_id,      index: { name: 'notification_for_message' }
    t.integer  :conversation_id, index: { name: 'notification_for_conversation' }
  end
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:all) do
    FactoryGirl.reload
  end

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
