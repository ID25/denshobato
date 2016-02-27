require 'spec_helper'
Denshobato.autoload :Conversation, 'denshobato/models/conversation'
Denshobato.autoload :Message, 'denshobato/models/message'

describe Denshobato::Blacklist, type: :model do
  describe '#add_to_blacklist' do
    let(:user) { create(:user, name: 'Eugene') }
    let(:duck) { create(:duck, name: 'Duck') }

    it 'user block duck' do
      user.add_to_blacklist(duck).save
      klass = user.add_to_blacklist(duck)

      expect(user.blacklist).to include Denshobato::Blacklist.find_by(blocker: user, blocked: duck)
      expect(klass.valid?).to be_falsey
      expect(klass.errors.full_messages).to eq ['Blocker User already in your blacklist', 'Blocker type User already in your blacklist']
    end
  end

  describe 'duck can`t start conversation with user' do
    let(:user) { create(:user, name: 'Eugene') }
    let(:duck) { create(:duck, name: 'Duck') }

    it 'user block duck, and duck can`t start conversation with user' do
      user.add_to_blacklist(duck).save

      result = duck.make_conversation_with(user)

      expect(result.valid?).to be_falsey
      expect(result.errors[:blacklist]).to eq ['You`re in blacklist']
    end
  end

  describe 'duck can`t send message to user' do
    let(:user) { create(:user, name: 'Eugene') }
    let(:duck) { create(:duck, name: 'Duck') }

    it 'user block duck, and duck can`t start conversation with user' do
      user.add_to_blacklist(duck).save

      result = duck.send_message('Hello, user', user)

      expect(result).to eq ['You`re in blacklist']
    end
  end
end
