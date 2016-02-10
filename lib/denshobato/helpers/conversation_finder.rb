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
      conversation.find_by(sender_id: sender.id, sender_class: class_name(sender), recipient_id: recipient.id, recipient_class: class_name(recipient))
    end

    def find_by_recipient
      conversation.find_by(sender_id: recipient.id, sender_class: class_name(recipient), recipient_id: sender.id, recipient_class: class_name(sender))
    end
  end
end
