module Denshobato
  module ViewHelper
    include Denshobato::HelperUtils

    def conversation_exists?(sender, recipient)
      # Check if sender and recipient already have conversation together.

      when_sender(sender, recipient) || when_recipient(sender, recipient)
    end

    %w(sender recipient).each do |name|
      # Create when_sender and when_recipient methods, which call finder methods find_by.., to fetch existing conversation.

      define_method "when_#{name}" do |sender, recipient|
        finder = Denshobato::ConversationFinder.new(sender, recipient)
        finder.send("find_by_#{name}")
      end
    end
  end
end
