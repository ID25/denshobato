require 'spec_helper'
Denshobato.autoload :Conversation, 'denshobato/models/conversation'

describe Denshobato::Conversation do
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
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
