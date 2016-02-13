require 'spec_helper'
Denshobato.autoload :CoreHelper, 'denshobato/helpers/core_helper'

describe Denshobato::ConversationFinder do
  include Denshobato::HelperUtils
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  describe '#find_by_sender' do
    let(:sender)    { User.create(name: 'X') }
    let(:recipient) { User.create(name: 'Y') }

    it 'return conversation when user is sender' do
      sender.make_conversation_with(recipient).save
      result = Denshobato::Conversation.find_by(sender_id: sender.id, sender_class: class_name(sender), recipient_id: recipient.id, recipient_class: class_name(recipient))
      finder = Denshobato::ConversationFinder.new(sender, recipient)

      expect(finder.find_by_sender).to eq result
    end

    it 'return conversation when user is recipient' do
      recipient.make_conversation_with(sender).save
      result = Denshobato::Conversation.find_by(sender_id: recipient.id, sender_class: class_name(recipient), recipient_id: sender.id, recipient_class: class_name(sender))
      finder = Denshobato::ConversationFinder.new(sender, recipient)

      expect(finder.find_by_recipient).to eq result
    end
  end
end
