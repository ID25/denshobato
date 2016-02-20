module Denshobato
  class ConversationFinder
    include Denshobato::HelperUtils

    attr_reader :sender, :recipient

    def initialize(sender, recipient)
      @sender    = sender
      @recipient = recipient
    end

    # OPTIMIZE: Metaprogram finder methods.
    def find_by_sender
      conversation.find_by(sender: sender, recipient: recipient)
    end

    def find_by_recipient
      conversation.find_by(sender: recipient, recipient: sender)
    end
  end
end
