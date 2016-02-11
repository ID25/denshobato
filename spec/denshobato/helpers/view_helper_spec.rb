require 'spec_helper'
require 'denshobato/helpers/view_helper'

describe Denshobato::ViewHelper do
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  class Helper
    include Denshobato::ViewHelper
  end

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

  describe '#interlocutor_name' do
    let(:sender)    { create(:user, name: 'John Smitt') }
    let(:recipient) { create(:duck, name: 'Donald', last_name: 'Duck') }

    it 'return name of recipient' do
      sender.make_conversation_with(recipient).save
      conversation = sender.find_conversation_with(recipient)

      expect(helper.interlocutor_name(sender, conversation, :name, :last_name)).to eq 'Donald Duck'
    end
  end
end
