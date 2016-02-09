require 'spec_helper'
require 'denshobato/conversation'

describe Denshobato::Conversation do
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  describe 'specific table in database' do
    conversation = Denshobato::Conversation

    it 'return correct database table' do
      expect(conversation.table_name).to eq 'denshobato_conversations'
    end
  end

  describe 'valiadtions' do
    let(:sender)    { User.create(name: 'Eugene') }
    let(:recipient) { User.create(name: 'Steve') }

    it 'validate sender_id presence' do
      model = sender.denshobato_conversations.build(recipient_id: recipient.id)
      model.sender_id = nil
      model.save

      expect(model.errors.full_messages.join('')).to eq 'Sender can`t be empty'
    end

    it 'validate recipient_id presence' do
      model = sender.denshobato_conversations.build
      model.save

      expect(model.errors.full_messages.join('')).to eq 'Recipient can`t be empty'
    end
  end

  describe 'validate uniqueness' do
    let(:sender)    { User.create(name: 'Eugene') }
    let(:recipient) { User.create(name: 'Steve') }

    it 'validate uniqueness' do
      sender.denshobato_conversations.create(recipient_id: recipient.id)
      model = recipient.denshobato_conversations.create(recipient_id: sender.id)

      expect(model.errors.full_messages.join('')).to eq 'Conversation You already have conversation with this user.'
    end

    it 'alias attribute for short' do
      expect(sender.conversations).to eq sender.denshobato_conversations
    end
  end
end
