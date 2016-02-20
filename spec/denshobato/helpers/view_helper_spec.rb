require 'spec_helper'

describe Denshobato::ViewHelper do
  helper = Helper.new

  describe '#conversation_exists?' do
    let(:sender)    { create(:user, name: 'X') }
    let(:recipient) { create(:user, name: 'Y') }

    it 'returns false, conversation not exists yet' do
      expect(helper.conversation_exists?(sender, recipient)).to be_falsey
    end

    it 'returns true, conversation exist' do
      sender.make_conversation_with(recipient).save

      expect(helper.conversation_exists?(sender, recipient)).to be_truthy
    end
  end

  describe '#can_create_conversation?' do
    let(:sender)    { create(:user, name: 'X') }

    it 'return true if sender isn`t recipient' do
      expect(helper.can_create_conversation?(sender, sender)).to be_falsey
    end
  end
end
