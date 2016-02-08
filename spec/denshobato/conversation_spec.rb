require 'spec_helper'
require 'denshobato/conversation'

describe Denshobato::Conversation do
  describe 'specific table in database' do
    conversation = Denshobato::Conversation

    it 'return correct database table' do
      expect(conversation.table_name).to eq 'denshobato_conversations'
    end
  end
end
