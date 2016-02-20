require 'spec_helper'
require 'denshobato/extenders/core'

describe Denshobato::Extenders::Core do
  include Denshobato::HelperUtils
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  class Duck < ActiveRecord::Base
    denshobato_for :user
  end

  describe '#denshobato_for' do
    let(:user)          { create(:user, name: 'Eugene') }
    let(:recipient)     { create(:user, name: 'Johnny Depp') }
    let!(:conversation) { user.conversations.create(recipient: recipient) }

    it 'user has_many conversations' do
      expect(user.denshobato_conversations.count).to eq 1
      expect(user.denshobato_conversations.class.inspect).to include 'ActiveRecord_Associations_CollectionProxy'
    end

    it 'conversation belongs_to user' do
      expect(conversation.sender).to eq user
    end
  end

  describe '#make_conversation_with' do
    let(:sender)    { create(:user, name: 'Me') }
    let(:recipient) { create(:duck, name: 'You') }

    it 'create conversations' do
      model = sender.make_conversation_with(recipient)

      expect(model.sender).to    eq sender
      expect(model.recipient).to eq recipient
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

      error = mark.make_conversation_with(user)

      expect(user.conversations.count).to   eq 2
      expect(error.valid?).to be_falsey
      expect(error.errors[:conversation].join('')).to eq 'You already have conversation with this user.'
    end
  end

  describe '#find_conversation_with' do
    let(:user) { create(:user, name: 'DHH') }
    let(:duck) { create(:duck, name: 'Quack') }

    it 'find conversation with user and duck' do
      user.make_conversation_with(duck).save
      result       = user.find_conversation_with(duck)
      conversation = Denshobato::Conversation.find_by(sender: user, recipient: duck)

      expect(result).to eq conversation
    end
  end

  describe '#full_name' do
    let(:duck) { create(:duck, name: 'DHH') }

    it 'expect default full_name to model name' do
      expect(duck.full_name).to eq 'Duck'
    end

    it 'custom full_name' do
      Duck.class_eval do
        def full_name
          'Donalnd Duck'
        end
      end

      expect(duck.full_name).to eq 'Donalnd Duck'
    end
  end

  describe '#image' do
    let(:duck) { create(:duck, name: 'DHH') }

    it 'expect default image' do
      expect(duck.image).to eq 'http://i.imgur.com/pGHOaLg.png'
    end

    it 'custom image' do
      Duck.class_eval do
        def image
          'cat.jpg'
        end
      end

      expect(duck.image).to eq 'cat.jpg'
    end
  end
end
