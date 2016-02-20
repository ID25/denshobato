require 'spec_helper'
Denshobato.autoload :Conversation, 'denshobato/models/conversation'

describe Denshobato::Conversation do
  before :each do
    @user = create(:user, name: 'Eugene')
    @duck = create(:duck, name: 'Donalnd Duck')
    @mark = create(:user, name: 'Mark')
  end

  describe '#send_message' do
    it 'create message, if conversation not exists, then conversation will created, together with the message.' do
      @user.send_message('Hello John', @duck).save
      conversation = @user.find_conversation_with(@duck)
      @user.messages.first.send_notification(conversation.id)
      message = conversation.messages

      expect(@user.messages).to eq message
    end
  end

  describe 'return error, when create message directly, without conversation' do
    it 'get validation error' do
      message = @user.send_message_to(nil, body: 'Text')

      expect(message.join(', ')).to eq 'Conversation not present'
    end
  end

  describe 'update conversation updated_at when message was created' do
    it 'update conversation' do
      @user.make_conversation_with(@duck).save
      conversation = @user.find_conversation_with(@duck)
      @user.send_message_to(conversation.id, body: 'lol')

      expect(conversation.updated_at.utc.to_s).to eq Time.now.utc.to_s
    end
  end

  describe 'access_to_posting_message' do
    it 'user can`t post to duck and mark conversation' do
      @duck.make_conversation_with(@mark).save
      room = @duck.find_conversation_with(@mark)
      @duck.send_message_to(room.id, body: 'Hi Mark').save

      result = @user.send_message_to(room.id, body: 'Hi there')

      expect(result.valid?).to be_falsey
      expect(result.errors[:message].join('')).to eq 'You can`t post to this conversation'
    end
  end
end
