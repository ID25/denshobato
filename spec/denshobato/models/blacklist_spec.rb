require 'spec_helper'
Denshobato.autoload :Conversation, 'denshobato/models/conversation'
Denshobato.autoload :Message, 'denshobato/models/message'

describe Denshobato::Blacklist, type: :model do
  before :each do
    @user = create(:user, name: 'Eugene')
    @duck = create(:duck, name: 'Duck')

    @user.add_to_blacklist(@duck).save
  end

  describe '#add_to_blacklist' do
    context 'User blocked duck' do
      it 'user block duck' do
        klass = @user.add_to_blacklist(@duck)

        expect(@user.blacklist).to include Denshobato::Blacklist.find_by(blocker: @user, blocked: @duck)
        expect(klass.valid?).to be_falsey
        expect(klass.errors.full_messages).to eq ['Blocker User already in your blacklist', 'Blocker type User already in your blacklist']
      end
    end

    context 'duck can`t start conversation with user' do
      it 'user block duck, and duck can`t start conversation with user' do
        result = @duck.make_conversation_with(@user)

        expect(result.valid?).to be_falsey
        expect(result.errors[:blacklist]).to eq ['You`re in blacklist']
      end
    end

    context 'duck can`t send message to user' do
      it 'user block duck, and duck can`t start conversation with user' do
        result = @duck.send_message('Hello, user', @user)

        expect(result).to eq ['You`re in blacklist']
      end
    end

    context 'user can`t start conversation with blocked user' do
      it 'user block duck, and duck can`t start conversation with user' do
        result = @user.make_conversation_with(@duck)

        expect(result.valid?).to be_falsey
        expect(result.errors[:blacklist].join('')).to eq 'Remove user from blacklist, to start conversation'
      end
    end

    context 'user can`t send message to blocked user' do
      it 'user block duck, and duck can`t start conversation with user' do
        result = @user.send_message('Hello blocked user', @duck)

        expect(result.join('')).to eq 'Remove user from blacklist, to start conversation'
      end
    end
  end

  describe '#remove_from_blacklist' do
    it 'remove user from blacklist' do
      result = @user.remove_from_blacklist(@duck)
      result.destroy

      expect(@user.reload.blacklist).to match_array []
    end
  end

  describe '#my_blacklist' do
    it 'return collection with blocked users' do
      expect(@user.my_blacklist).to include Denshobato::Blacklist.find_by(blocker: @user, blocked: @duck)
    end
  end
end
