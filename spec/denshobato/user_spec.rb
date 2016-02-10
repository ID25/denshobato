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
    let(:sender)         { create(:user, name: 'Frodo') }
    let(:recipient)      { create(:user, name: 'Harry Potter') }
    let(:another_sender) { create(:user, name: 'Luke') }

    it 'return conversations where current user is present as sender or recipient' do
      recipient.conversations.create(recipient_id: sender.id, recipient_class: sender.class.name, sender_class: recipient.class.name)
      another_sender.conversations.create(recipient_id: sender.id, recipient_class: sender.class.name, sender_class: recipient.class.name)

      expect(Denshobato::Conversation.conversations_for(sender)).to eq sender.my_conversations
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
      conversation = duck.conversations.create(sender_class: duck.class.name, recipient_id: sender.id, recipient_class: sender.class.name)

      expect(sender.conversations[0]).to eq conversation
    end
  end
end
