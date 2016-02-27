module Denshobato
  module ViewHelper
    include Denshobato::HelperUtils
    include Denshobato::ViewMessagingHelper
    include Denshobato::ReactHelper

    def conversation_exists?(sender, recipient)
      # Check if sender and recipient already have conversation together.

      hato_conversation.find_by(sender: sender, recipient: recipient)
    end

    def can_create_conversation?(sender, recipient)
      # If current sender is current recipient, return false

      sender == recipient ? false : true
    end

    def fill_conversation_form(form, recipient)
      # = form_for @conversation do |form|
      ### = fill_conversation_form(form, @conversation)
      ### = f.submit 'Start Chating', class: 'btn btn-primary'

      recipient_id   = form.hidden_field :recipient_id,   value: recipient.id
      recipient_type = form.hidden_field :recipient_type, value: recipient.class.name

      recipient_id + recipient_type
    end

    def fill_message_form(form, user, room)
      # @message = current_user.build_conversation_message(@conversation)
      # = form_for [@conversation, @message] do |form|
      ### = form.text_field :body
      ### = fill_message_form(form, @message)
      ### = form.submit

      sender_id       = form.hidden_field :sender_id,       value: user.id
      sender_class    = form.hidden_field :sender_type,     value: user.class.name
      conversation_id = form.hidden_field :conversation_id, value: room

      sender_id + sender_class + conversation_id
    end
  end
end
