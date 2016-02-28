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

    def user_in_black_list?(blocker, blocked)
      hato_blacklist.where(blocker: blocker, blocked: blocked).present?
    end

    def devise_url_helper(action, user, controller)
      # Polymorphic devise urls
      # E.g, you have two models, seller and customer
      # Then you can create helper like current_account
      # And use this method for url's

      # devise_url_helper(:edit, current_account, :registration)
      # => :edit_seller_registration, or :edit_customer_registration

      "#{action}_#{user.class.name.downcase}_#{controller}".to_sym
    end

    def fill_conversation_form(form, recipient)
      # = form_for @conversation do |form|
      ### = fill_conversation_form(form, @conversation)
      ### = f.submit 'Start Chating', class: 'btn btn-primary'

      recipient_id   = form.hidden_field :recipient_id,   value: recipient.id
      recipient_type = form.hidden_field :recipient_type, value: recipient.class.name

      recipient_id + recipient_type
    end

    def fill_message_form(form, user, room_id)
      # @message = current_user.build_conversation_message(@conversation)
      # = form_for [@conversation, @message] do |form|
      ### = form.text_field :body
      ### = fill_message_form(form, @message)
      ### = form.submit

      room_id = room_id.id if room_id.is_a?(ActiveRecord::Base)

      sender_id       = form.hidden_field :sender_id,       value: user.id
      sender_class    = form.hidden_field :sender_type,     value: user.class.name
      conversation_id = form.hidden_field :conversation_id, value: room_id

      sender_id + sender_class + conversation_id
    end
  end
end
