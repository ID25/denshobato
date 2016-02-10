require 'spec_helper'
require 'denshobato/extenders/core'

describe Denshobato::Extenders::Core do
  include Denshobato::HelperUtils
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  describe '#denshobato_for' do
    let(:user)          { create(:user, name: 'Eugene') }
    let(:recipient)     { create(:user, name: 'Johnny Depp') }
    let!(:conversation) { user.denshobato_conversations.create(recipient_id: recipient.id) }

    it 'user has_many conversations' do
      expect(user.denshobato_conversations.count).to eq 1
      expect(user.denshobato_conversations.class.inspect).to include 'ActiveRecord_Associations_CollectionProxy'
    end

    it 'conversation belongs_to user' do
      expect(conversation.user).to eq user
    end
  end

  describe '#make_conversation_with' do
    let(:sender)    { create(:user, name: 'Me') }
    let(:recipient) { create(:duck, name: 'You') }

    it 'create conversations' do
      model = sender.make_conversation_with(recipient)

      expect(model.sender_class).to    eq sender.class.name
      expect(model.recipient_id).to    eq recipient.id
      expect(model.recipient_class).to eq recipient.class.name
      expect(model.valid?).to be_truthy
    end
  end

  describe '#my_conversations' do
    let(:user) { create(:user, name: 'DHH') }
    let(:duck) { create(:duck, name: 'Quack') }
    let(:mark) { create(:user, name: 'Mark') }

    it 'return all conversations where user as sender or recipient' do
      mark.make_conversation_with(user).save
      duck.make_conversation_with(user).save

      expect(user.my_conversations).to include mark.conversations[0]
      expect(user.my_conversations).to include duck.conversations[0]
    end
  end

  describe '#find_conversation_with' do
    let(:user) { create(:user, name: 'DHH') }
    let(:duck) { create(:duck, name: 'Quack') }

    it 'find conversation with user and duck' do
      user.make_conversation_with(duck).save
      result       = user.find_conversation_with(duck)
      conversation = Denshobato::Conversation.find_by(sender_id: user.id, sender_class: class_name(user), recipient_id: duck.id, recipient_class: class_name(duck))

      expect(result).to eq conversation
    end
  end
end
