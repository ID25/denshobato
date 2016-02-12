require 'spec_helper'
require 'denshobato/models/conversation'
require 'denshobato/models/message'

describe Denshobato::Conversation do
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  describe '#send_message' do
    let(:user)  { create(:user, name: 'Mike') }
    let(:osama) { create(:user, name: 'Steve') }

    it 'create message, if conversation not exists, then conversation will created, together with the message.' do
      conversation_message = user.send_message('Hello John', osama)
      message = Denshobato::Message.first

      expect(conversation_message).to eq message
    end
  end

  describe 'return error, when create message directly, without conversation' do
    let(:user) { create(:user, name: 'Mike') }

    it 'get validation error' do
      message = user.messages.create(body: 'Text')

      expect(message.valid?).to be_falsey
      expect(message.errors.full_messages.join(', ')).to eq "Conversation can't be blank, Sender class can't be blank"
    end
  end

  describe 'update conversation updated_at when message was created' do
    let(:user)  { create(:user, name: 'Mike') }
    let(:osama) { create(:user, name: 'Steve') }

    it 'does something' do
      user.make_conversation_with(osama).save
      user.messages.create(body: 'lol', sender_class: user.class.name, conversation_id: user.my_conversations[0].id)
      message = user.messages[0]

      expect(message.conversation.updated_at.utc.to_s).to eq Time.now.utc.to_s
    end
  end

  describe '#sender' do
    let(:user)  { create(:user, name: 'Mike') }
    let(:osama) { create(:user, name: 'Steve') }

    it 'return message creator' do
      user.send_message('Hello', osama)

      expect(Denshobato::Message.first.sender).to eq user
    end
  end
end
