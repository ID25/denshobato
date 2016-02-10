module Denshobato
  module ViewHelper
    def conversation_exists?(sender, recipient)
      # Check if sender and recipient already have conversation together.

      when_sender(sender, recipient) || when_recipient(sender, recipient)
    end

    private

    def when_sender(sender, recipient)
      conversation.find_by(sender_id: sender.id, sender_class: name(sender), recipient_id: recipient.id, recipient_class: name(recipient)).present?
    end

    def when_recipient(sender, recipient)
      conversation.find_by(sender_id: recipient.id, sender_class: name(recipient), recipient_id: sender.id, recipient_class: name(sender)).present?
    end

    def conversation
      Denshobato::Conversation
    end

    def name(model)
      model.class.name
    end
  end
end
