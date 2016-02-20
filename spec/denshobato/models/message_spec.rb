require 'spec_helper'
Denshobato.autoload :Conversation, 'denshobato/models/conversation'
Denshobato.autoload :Message, 'denshobato/models/message'

describe Denshobato::Conversation do
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  describe '#send_message' do
    let(:user)  { create(:user, name: 'Mike') }
    let(:osama) { create(:user, name: 'Steve') }

    it 'create message, if conversation not exists, then conversation will created, together with the message.' do
      user.send_message('Hello John', osama).save
      conversation = user.find_conversation_with(osama)
      user.messages.first.send_notification(conversation.id)
      message = conversation.messages

      expect(user.messages).to eq message
    end
  end

  describe 'return error, when create message directly, without conversation' do
    let(:user) { create(:user, name: 'Mike') }

    it 'get validation error' do
      message = user.send_message_to(nil, body: 'Text')

      expect(message.join(', ')).to eq 'Conversation not present'
    end
  end

  describe 'update conversation updated_at when message was created' do
    let(:user)  { create(:user, name: 'Mike') }
    let(:osama) { create(:user, name: 'Steve') }

    it 'update conversation' do
      user.make_conversation_with(osama).save
      conversation = user.find_conversation_with(osama)
      user.send_message_to(conversation.id, body: 'lol')

      expect(conversation.updated_at.utc.to_s).to eq Time.now.utc.to_s
    end
  end
end
