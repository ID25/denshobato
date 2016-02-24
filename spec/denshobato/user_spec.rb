require 'spec_helper'
Denshobato.autoload :Conversation, 'denshobato/models/conversation'

describe Denshobato::Conversation do
  describe 'user conversations' do
    let(:sender)         { create(:user, name: 'Frodo') }
    let(:recipient)      { create(:user, name: 'Harry Potter') }
    let(:another_sender) { create(:user, name: 'Luke') }

    it 'return conversations where current user is present as sender or recipient' do
      recipient.hato_conversations.create(recipient: sender)
      another_sender.hato_conversations.create(recipient: sender)

      expect(sender.hato_conversations).to eq sender.hato_conversations
    end
  end

  describe 'alias attribute for short' do
    let(:sender) { create(:user, name: 'Frodo') }

    it 'return same association array' do
      expect(sender.hato_conversations).to eq sender.denshobato_conversations
    end
  end

  describe 'chating between two models' do
    let(:sender) { create(:user, name: 'Frodo') }
    let(:duck)   { create(:duck, name: 'Quack') }

    it 'conversations between user and duck' do
      duck.hato_conversations.create(recipient: sender)

      conv1 = duck.find_conversation_with(sender)
      conv2 = sender.find_conversation_with(duck)

      expect(conv1.sender).to eq conv2.recipient
    end
  end
end
