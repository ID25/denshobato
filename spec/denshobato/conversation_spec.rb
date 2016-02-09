require 'spec_helper'
require 'denshobato/conversation'
require 'denshobato/message'

describe Denshobato::Conversation do
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  before :each do
    @sender    = User.create(name: 'Eugene')
    @recipient = User.create(name: 'Steve')
  end

  describe 'specific table in database' do
    conversation = Denshobato::Conversation

    it 'return correct database table' do
      expect(conversation.table_name).to eq 'denshobato_conversations'
    end
  end

  describe 'valiadtions' do
    it 'validate sender_id presence' do
      model = @sender.denshobato_conversations.build(recipient_id: @recipient.id)
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
    it 'validate uniqueness' do
      @sender.denshobato_conversations.create(recipient_id: @recipient.id)
      model = @recipient.denshobato_conversations.create(recipient_id: @sender.id)

      expect(model.errors.full_messages.join('')).to eq 'Conversation You already have conversation with this user.'
    end

    it 'alias attribute for short' do
      expect(@sender.conversations).to eq @sender.denshobato_conversations
    end
  end

  describe 'conversations_for scope' do
    let(:another_sender) { User.create(name: 'Harry Potter') }

    it 'return conversations where current user is present as sender or recipient' do
      @recipient.conversations.create(recipient_id: @sender.id)
      another_sender.conversations.create(recipient_id: @sender.id)

      expect(Denshobato::Conversation.conversations_for(@sender)).to eq @sender.my_conversations
    end
  end

  describe 'has_many messages' do
    it 'return Associations::CollectionProxy' do
      @recipient.conversations.create(recipient_id: @sender.id)
      conversation = @recipient.conversations.first
      conversation.messages.create(body: 'Moon Sonata', sender_id: @recipient.id)

      expect(conversation.messages).to eq Denshobato::Message.where(conversation_id: conversation.id)
    end
  end
end
