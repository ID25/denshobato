require 'spec_helper'
require 'denshobato/models/conversation'

describe Denshobato::Conversation do
  include Denshobato::HelperUtils
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  class Duck < ActiveRecord::Base
    denshobato_for :user
  end

  describe 'conversations_for scope' do
    let(:sender)         { User.create(name: 'Frodo') }
    let(:recipient)      { User.create(name: 'Harry Potter') }
    let(:another_sender) { User.create(name: 'Luke') }

    it 'return conversations where current user is present as sender or recipient' do
      recipient.conversations.create(recipient_id: sender.id, recipient_class: sender.class.name, sender_class: recipient.class.name)
      another_sender.conversations.create(recipient_id: sender.id, recipient_class: sender.class.name, sender_class: recipient.class.name)

      expect(Denshobato::Conversation.conversations_for(sender)).to eq sender.my_conversations
    end
  end

  describe 'alias attribute for short' do
    let(:sender) { User.create(name: 'Frodo') }

    it 'return same association array' do
      expect(sender.conversations).to eq sender.denshobato_conversations
    end
  end

  describe 'chating between two models' do
    let(:sender) { User.create(name: 'Frodo') }
    let(:duck)   { Duck.create(name: 'Donald') }

    it 'conversations between user and duck' do
      conversation = duck.conversations.create(sender_class: duck.class.name, recipient_id: sender.id, recipient_class: sender.class.name)

      expect(sender.conversations[0]).to eq conversation
    end
  end

  describe '#make_conversation_with' do
    let(:sender)    { User.create(name: 'Me') }
    let(:recipient) { Duck.create(name: 'You') }

    it 'create conversations' do
      model = sender.make_conversation_with(recipient)

      expect(model.sender_class).to    eq sender.class.name
      expect(model.recipient_id).to    eq recipient.id
      expect(model.recipient_class).to eq recipient.class.name
      expect(model.valid?).to be_truthy
    end
  end

  describe '#my_conversations' do
    let(:user) { User.create(name: 'DHH') }
    let(:duck) { Duck.create(name: 'Quack') }
    let(:mark) { User.create(name: 'Mark') }

    it 'return all conversations where user as sender or recipient' do
      mark.make_conversation_with(user).save
      duck.make_conversation_with(user).save

      expect(user.my_conversations).to include mark.conversations[0]
      expect(user.my_conversations).to include duck.conversations[0]
    end
  end

  describe '#find_conversation_with' do
    let(:user) { User.create(name: 'DHH') }
    let(:duck) { Duck.create(name: 'Quack') }

    it 'find conversation with user and duck' do
      user.make_conversation_with(duck).save
      result       = user.find_conversation_with(duck)
      conversation = Denshobato::Conversation.find_by(sender_id: user.id, sender_class: class_name(user), recipient_id: duck.id, recipient_class: class_name(duck))

      expect(result).to eq conversation
    end
  end
end
