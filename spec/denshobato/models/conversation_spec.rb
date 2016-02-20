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
    @sender    = create(:user, name: 'Eugene')
    @recipient = create(:user, name: 'Steve')
  end

  describe 'specific table in database' do
    conversation = Denshobato::Conversation

    it 'return correct database table' do
      expect(conversation.table_name).to eq 'denshobato_conversations'
    end
  end

  describe 'valiadtions' do
    it 'validate sender_id presence' do
      model = @sender.conversations.build(recipient: @recipient, sender: @sender)
      model.sender_id = nil
      model.save

      expect(model.errors.full_messages.join(', ')).to eq "Sender can't be blank"
    end

    it 'validate recipient_id presence' do
      model = @sender.conversations.build
      model.save

      expect(model.errors.full_messages.join(', ')).to eq "Recipient can't be blank, Recipient type can't be blank"
    end
  end

  describe 'validate uniqueness' do
    let(:admin) { create(:admin) }
    let(:duck)  { create(:duck) }

    it 'validate uniqueness' do
      admin.conversations.create(recipient: @recipient, sender: admin)
      model = @recipient.conversations.create(recipient: admin, sender: @recipient)

      expect(model.errors.messages[:conversation].join('')).to eq 'You already have conversation with this user.'
    end
  end

  describe 'has_many messages' do
    it 'return Associations::CollectionProxy' do
      @recipient.conversations.create(recipient: @sender, sender: @recipient_id)
      conversation = @recipient.conversations.first
      message = @recipient.messages.build(body: 'Moon Sonata')
      message.save

      message.send_notification(conversation.id)

      expect(conversation.messages).to eq @recipient.messages
    end
  end

  describe 'check sender validation' do
    it 'get error, when sender create conversation with yourself' do
      result = @sender.make_conversation_with(@sender)

      expect(result.valid?).to be_falsey
      expect(result.errors[:conversation].join('')).to eq 'You can`t create conversation with yourself'
    end
  end
end
