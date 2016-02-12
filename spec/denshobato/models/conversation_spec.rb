require 'spec_helper'
require 'denshobato/models/conversation'
require 'denshobato/models/message'

describe Denshobato::Conversation do
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  class Admin < ActiveRecord::Base
    denshobato_for :user
  end

  class Duck < ActiveRecord::Base
    denshobato_for :user
  end

  before :each do
    @sender    = create(:user, name: 'Eugene')
    @recipient = create(:user, name: 'Steve')
  end

  describe 'specific table in database' do
    conversation = Denshobato::Conversation

    it 'return correct database table' do
      expect(conversation.table_name).to eq 'denshobato_conversations'
    end
  end

  describe 'valiadtions' do
    it 'validate sender_id presence' do
      model = @sender.conversations.build(recipient_id: @recipient.id, recipient_class: @recipient.class.name, sender_class: @sender.class.name)
      model.sender_id = nil
      model.save

      expect(model.errors.full_messages.join('')).to eq 'Sender can`t be empty'
    end

    it 'validate recipient_id presence' do
      model = @sender.denshobato_conversations.build
      model.save

      expect(model.errors.full_messages.join('')).to eq 'Recipient can`t be empty'
    end
  end

  describe 'validate uniqueness' do
    let(:admin) { create(:admin) }
    let(:duck)  { create(:duck) }

    it 'validate uniqueness' do
      admin.conversations.create(recipient_id: @recipient.id, recipient_class: @recipient.class.name, sender_class: admin.class.name)
      model = @recipient.conversations.create(recipient_id: admin.id, recipient_class: admin.class.name, sender_class: @recipient.class.name)

      expect(model.errors.messages[:conversation].join('')).to eq 'You already have conversation with this user.'
    end
  end

  describe 'has_many messages' do
    it 'return Associations::CollectionProxy' do
      @recipient.conversations.create(recipient_id: @sender.id, recipient_class: @sender.class.name, sender_class: @recipient_id.class.name)
      conversation = @recipient.conversations.first
      conversation.messages.create(body: 'Moon Sonata', sender_id: @recipient.id, sender_class: @recipient.class.name)

      expect(conversation.messages).to eq Denshobato::Message.where(conversation_id: conversation.id)
    end
  end

  describe 'check sender validation' do
    it 'get error, when sender create conversation with yourself' do
      result = @sender.make_conversation_with(@sender)

      expect(result.valid?).to be_falsey
      expect(result.errors[:conversation].join('')).to eq 'You can`t create conversation with yourself'
    end
  end
end
