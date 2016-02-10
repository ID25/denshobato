require 'spec_helper'
require 'denshobato/extenders/core'

describe Denshobato::Extenders::Core do
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
end
