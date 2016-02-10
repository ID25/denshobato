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

    def populate_conversation_form(form, conversation)
      # = form_for @conversation do |form|
      ### = populate_conversation_form(form, @conversation)
      ### = f.submit 'Start Chating', class: 'btn btn-primary'

      sender_id       = form.hidden_field :sender_id,       value: conversation.sender_id
      sender_class    = form.hidden_field :sender_class,    value: conversation.sender_class
      recipient_id    = form.hidden_field :recipient_id,    value: conversation.recipient_id
      recipient_class = form.hidden_field :recipient_class, value: conversation.recipient_class

      sender_id + sender_class + recipient_id + recipient_class
    end
  end
end
