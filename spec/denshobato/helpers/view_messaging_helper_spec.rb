require 'spec_helper'
require 'denshobato/helpers/view_messaging_helper'

describe Denshobato::ViewHelper do
  ActiveRecord::Base.extend Denshobato::Extenders::Core

  class User < ActiveRecord::Base
    denshobato_for :user
  end

  class Helper
    include Denshobato::ViewMessagingHelper

    def image_tag(image, css)
      "<img src='#{image}' class='#{css}'></img>"
    end
  end

  helper = Helper.new

  describe '#interlocutor_name' do
    let(:sender)    { create(:user, name: 'John Smitt') }
    let(:recipient) { create(:duck, name: 'Donald', last_name: 'Duck') }

    it 'return name of recipient' do
      sender.make_conversation_with(recipient).save
      conversation = sender.find_conversation_with(recipient)

      expect(helper.interlocutor_name(sender, conversation, :name, :last_name)).to eq 'Donald Duck'
    end
  end

  describe '#interlocutor_avatar' do
    let(:sender)    { create(:user, name: 'John Smitt') }
    let(:recipient) { create(:duck, name: 'Donald', last_name: 'Duck') }

    it 'return <img src> with url and css class' do
      sender.make_conversation_with(recipient).save
      conversation = sender.find_conversation_with(recipient)
      recipient[:avatar] = 'cat_image.jpg'
      recipient.save
      image = helper.interlocutor_avatar(sender, :avatar, conversation, 'img-rounded')

      expect(image).to eq "<img src='cat_image.jpg' class='{:class=>\"img-rounded\"}'></img>"
    end
  end
end
