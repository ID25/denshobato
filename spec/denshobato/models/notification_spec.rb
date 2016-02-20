require 'spec_helper'

describe Denshobato::Notification, type: :model do
  it { should validate_presence_of(:message_id) }
  it { should validate_presence_of(:conversation_id) }
  it { should validate_uniqueness_of(:message_id).scoped_to(:conversation_id) }
  it { should belong_to(:denshobato_message) }
  it { should belong_to(:denshobato_conversation) }

  describe 'specific table in database' do
    it 'return correct database table' do
      expect(Denshobato::Notification.table_name).to eq 'denshobato_notifications'
    end
  end

  describe 'send notifications to users after create message' do
    let(:user) { create(:user, name: 'DHH') }
    let(:duck) { create(:duck, name: 'Quack') }

    it 'save message and send notifications' do
      user.make_conversation_with(duck).save
      room = user.find_conversation_with(duck)
      msg  = user.send_message_to(room.id, body: 'Hello')
      msg.save
      msg.send_notification(room.id)

      expect(Denshobato::Notification.count).to eq 2
    end
  end
end
