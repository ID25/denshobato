module Denshobato
  module ViewHelper
    include Denshobato::HelperUtils
    include Denshobato::ViewMessagingHelper
    include Denshobato::ReactHelper

    def conversation_exists?(sender, recipient)
      # Check if sender and recipient already have conversation together.

      conversation.find_by(sender: sender, recipient: recipient)
    end

    def can_create_conversation?(sender, recipient)
      # If current sender is current recipient, return false

      sender == recipient ? false : true
    end

    def fill_conversation_form(form, conversation)
      # = form_for @conversation do |form|
      ### = fill_conversation_form(form, @conversation)
      ### = f.submit 'Start Chating', class: 'btn btn-primary'

      sender_id       = form.hidden_field :sender_id,       value: conversation.sender_id
      sender_class    = form.hidden_field :sender_class,    value: conversation.sender_class
      recipient_id    = form.hidden_field :recipient_id,    value: conversation.recipient_id
      recipient_class = form.hidden_field :recipient_class, value: conversation.recipient_class

      sender_id + sender_class + recipient_id + recipient_class
    end

    def fill_message_form(form, message)
      # @message = current_user.build_conversation_message(@conversation)
      # = form_for [@conversation, @message] do |form|
      ### = form.text_field :body
      ### = fill_message_form(form, @message)
      ### = form.submit

      sender_id       = form.hidden_field :sender_id,       value: message.sender_id
      sender_class    = form.hidden_field :sender_class,    value: message.sender_class
      conversation_id = form.hidden_field :conversation_id, value: message.conversation_id

      sender_id + sender_class + conversation_id
    end
  end
end
