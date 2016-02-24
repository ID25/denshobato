require 'spec_helper'
require 'denshobato/extenders/core'

describe Denshobato::Extenders::Core do
  before :each do
    @user = create(:user, name: 'Eugene')
    @duck = create(:duck, name: 'Donalnd Duck')
    @mark = create(:user, name: 'Mark')
  end

  describe '#denshobato_for' do
    let!(:conversation) { @user.hato_conversations.create(recipient: @duck) }

    it 'user has_many conversations' do
      expect(@user.denshobato_conversations.count).to eq 1
      expect(@user.denshobato_conversations.class.inspect).to include 'ActiveRecord_Associations_CollectionProxy'
    end

    it 'conversation belongs_to user' do
      expect(conversation.sender).to eq @user
    end
  end

  describe '#make_conversation_with' do
    it 'create conversations' do
      model = @user.make_conversation_with(@duck)

      expect(model.sender).to    eq @user
      expect(model.recipient).to eq @duck
      expect(model.valid?).to be_truthy
    end
  end

  describe '#conversations' do
    it 'return all conversations where user as sender or recipient' do
      @mark.make_conversation_with(@user).save
      @duck.make_conversation_with(@user).save

      error = @mark.make_conversation_with(@user)

      expect(@user.hato_conversations.count).to eq 2
      expect(error.valid?).to be_falsey
      expect(error.errors[:conversation].join('')).to eq 'You already have conversation with this user.'
    end
  end

  describe '#find_conversation_with' do
    it 'find conversation with user and duck' do
      @user.make_conversation_with(@duck).save
      result       = @user.find_conversation_with(@duck)
      conversation = Denshobato::Conversation.find_by(sender: @user, recipient: @duck)

      expect(result).to eq conversation
    end
  end

  describe '#full_name' do
    it 'expect default full_name to model name' do
      expect(@duck.full_name).to eq 'Duck'
    end

    it 'custom full_name' do
      Duck.class_eval do
        def full_name
          'Donalnd Duck'
        end
      end

      expect(@duck.full_name).to eq 'Donalnd Duck'
    end
  end

  describe '#image' do
    it 'expect default image' do
      expect(@duck.image).to eq 'http://i.imgur.com/pGHOaLg.png'
    end

    it 'custom image' do
      Duck.class_eval do
        def image
          'cat.jpg'
        end
      end

      expect(@duck.image).to eq 'cat.jpg'
    end
  end

  describe '#send_message_to' do
    it 'initialize message' do
      @user.make_conversation_with(@duck).save
      room = @user.find_conversation_with(@duck)

      msg = @user.send_message_to(room.id, body: 'Hello')

      expect(msg.body).to   eq 'Hello'
      expect(msg.author).to eq @user
    end

    it 'save message and send notifications' do
      @user.make_conversation_with(@duck).save
      room = @user.find_conversation_with(@duck)
      msg  = @user.send_message_to(room.id, body: 'Hello')
      msg.save
      msg.send_notification(room.id)

      expect(Denshobato::Notification.count).to eq 2
    end
  end
end
