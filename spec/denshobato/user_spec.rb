require 'spec_helper'
Denshobato.autoload :Conversation, 'denshobato/models/conversation'

describe Denshobato::Conversation do
  include Denshobato::HelperUtils
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  class Duck < ActiveRecord::Base
    denshobato_for :user
  end

  describe 'user conversations' do
    let(:sender)         { create(:user, name: 'Frodo') }
    let(:recipient)      { create(:user, name: 'Harry Potter') }
    let(:another_sender) { create(:user, name: 'Luke') }

    it 'return conversations where current user is present as sender or recipient' do
      recipient.conversations.create(recipient: sender)
      another_sender.conversations.create(recipient: sender)

      expect(sender.conversations).to eq sender.conversations
    end
  end

  describe 'alias attribute for short' do
    let(:sender) { create(:user, name: 'Frodo') }

    it 'return same association array' do
      expect(sender.conversations).to eq sender.denshobato_conversations
    end
  end

  describe 'chating between two models' do
    let(:sender) { create(:user, name: 'Frodo') }
    let(:duck)   { create(:duck, name: 'Quack') }

    it 'conversations between user and duck' do
      duck.conversations.create(recipient: sender)

      conv1 = duck.find_conversation_with(sender)
      conv2 = sender.find_conversation_with(duck)

      expect(conv1.sender).to eq conv2.recipient
    end
  end
end
