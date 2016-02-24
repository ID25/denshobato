require 'spec_helper'
Denshobato.autoload :Conversation, 'denshobato/models/conversation'
Denshobato.autoload :Message, 'denshobato/models/message'

describe Denshobato::Conversation, type: :model do
  it { should validate_presence_of(:sender_id) }
  it { should validate_presence_of(:sender_type) }
  it { should validate_presence_of(:recipient_id) }
  it { should validate_presence_of(:recipient_type) }
  it { should belong_to(:sender) }
  it { should belong_to(:recipient) }
  it { should have_many(:denshobato_notifications) }

  before :each do
    @user = create(:user, name: 'DHH')
    @duck = create(:duck, name: 'Quack')
    @wolf = create(:user, name: 'Wolf')
  end

  describe 'specific table in database' do
    conversation = Denshobato::Conversation

    it 'return correct database table' do
      expect(conversation.table_name).to eq 'denshobato_conversations'
    end
  end

  describe 'valiadtions' do
    it 'validate sender_id presence' do
      model = @user.conversations.build(recipient: @duck, sender: @user)
      model.sender_id = nil
      model.save

      expect(model.errors.full_messages.join(', ')).to eq "Sender can't be blank"
    end

    it 'validate recipient_id presence' do
      model = @user.conversations.build
      model.save

      expect(model.errors.full_messages.join(', ')).to eq "Recipient can't be blank, Recipient type can't be blank"
    end
  end

  describe 'validate uniqueness' do
    it 'validate uniqueness' do
      @user.conversations.create(recipient: @duck, sender: @user)
      model = @duck.conversations.create(recipient: @user, sender: @duck)

      expect(model.errors.messages[:conversation].join('')).to eq 'You already have conversation with this user.'
    end
  end

  describe 'has_many messages' do
    it 'return Associations::CollectionProxy' do
      @duck.conversations.create(recipient: @user, sender: @duck)
      conversation = @duck.conversations.first
      message      = @duck.messages.build(body: 'Moon Sonata')
      message.save

      message.send_notification(conversation.id)

      expect(conversation.messages).to eq @duck.messages
    end
  end

  describe 'check sender validation' do
    it 'get error, when sender create conversation with yourself' do
      result = @user.make_conversation_with(@user)

      expect(result.valid?).to be_falsey
      expect(result.errors[:conversation].join('')).to eq 'You can`t create conversation with yourself'
    end
  end

  describe 'remove messages, if other users remove conversation' do
    it 'both users remove their conversation, messages from this conversation will delete' do
      create_conversation_and_messages
      @user.conversations[0].destroy
      @duck.conversations[0].destroy

      expect(@room.messages).to eq []
    end
  end

  describe 'conversation member has access to messages, when other member delete conversation' do
    it 'user remove conversation, messages still in db' do
      create_conversation_and_messages
      @user.conversations[0].destroy
      room2 = @duck.find_conversation_with(@user)

      expect(room2.messages).to eq [@msg, @msg2]
    end
  end

  describe 'user create new conversation with same recipient' do
    it 'user with new conversation see only new messages' do
      create_conversation_and_messages

      @user.conversations.destroy_all
      @user.make_conversation_with(@duck).save
      room  = @user.find_conversation_with(@duck)
      room2 = @duck.find_conversation_with(@user)
      @msg  = @user.send_message('Hello again', @duck)
      @msg.save
      @msg.send_notification(room.id)

      expect(room.messages).not_to eq room2.messages
    end
  end

  describe 'remove extra messages, after multiple removing conversation' do
    it 'remove messages which not belong to any conversations' do
      @user.make_conversation_with(@duck).save
      room = @user.find_conversation_with(@duck)
      msg  = @user.send_message('First user message', @duck)
      create_msg(msg, room)

      duck_room = @duck.find_conversation_with(@user)
      msg2 = @duck.send_message('First duck message', @user)
      create_msg(msg2, duck_room)

      room.destroy
      @user.make_conversation_with(@duck).save

      msg3      = @user.send_message('Hello again', @duck)
      new_room  = @user.find_conversation_with(@duck)
      create_msg(msg3, new_room)

      duck_room.destroy
      @duck.make_conversation_with(@user).save
      new_duck_room = @duck.find_conversation_with(@user)
      msg4 = @duck.send_message('In new duck conversation', @user)
      create_msg(msg4, new_duck_room)

      expect(new_room.messages).to eq [msg3, msg4]
      expect(new_duck_room.messages).to eq [msg4]
      expect { msg3.destroy }.to change { msg3.errors.full_messages.join('') }
        .from('')
        .to('Can`t delete message, as long as it belongs to the conversation')
    end
  end

  describe '#to_trash' do
    it 'move conversation to trash' do
      create_conversation(@user, @duck, @wolf)
      @conversation.to_trash

      expect(@conversation.trashed).to be_truthy
    end
  end

  describe '#from_trash' do
    it 'move conversation to trash' do
      create_conversation(@user, @duck, @wolf)
      @conversation.to_trash
      @conversation.from_trash

      expect(@conversation.trashed).to be_falsey
    end
  end

  describe '#my_conversations' do
    it 'return active conversations' do
      create_conversation(@user, @duck, @wolf)
      @conversation.to_trash

      expect(@user.my_conversations).not_to include @conversation
    end
  end

  describe '#trashed_conversations' do
    it 'return trashed conversations' do
      create_conversation(@user, @duck, @wolf)
      @conversation.to_trash

      expect(@user.trashed_conversations).to     include @conversation
      expect(@user.trashed_conversations).not_to include @user.my_conversations
    end
  end
end
