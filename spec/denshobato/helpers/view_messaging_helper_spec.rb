require 'spec_helper'
Denshobato.autoload :ViewMessagingHelper, 'denshobato/helpers/view_messaging_helper'

describe Denshobato::ViewMessagingHelper do
  class Helper
    include Denshobato::ViewMessagingHelper

    def image_tag(image, css)
      "<img src='#{image}' class='#{css}'></img>"
    end
  end

  helper = Helper.new

  before :each do
    @sender    = create(:user, name: 'John Smitt')
    @recipient = create(:duck, name: 'Donald', last_name: 'Duck')
  end

  describe '#interlocutor_name' do
    it 'return name of recipient' do
      @sender.make_conversation_with(@recipient).save
      conversation = @sender.find_conversation_with(@recipient)

      expect(helper.interlocutor_name(@sender, conversation, :name, :last_name)).to eq 'John Smitt'
    end
  end

  describe '#interlocutor_avatar' do
    it 'return <img src> with url and css class' do
      @sender.make_conversation_with(@recipient).save
      conversation = @sender.find_conversation_with(@recipient)
      @recipient[:avatar] = 'cat_image.jpg'
      @recipient.save
      image = helper.interlocutor_avatar(@sender, :avatar, conversation, 'img-rounded')

      expect(image).to eq "<img src='cat_image.jpg' class='{:class=>\"img-rounded\"}'></img>"
    end
  end
end
