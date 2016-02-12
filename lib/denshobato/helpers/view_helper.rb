module Denshobato
  module ViewHelper
    include Denshobato::HelperUtils

    def conversation_exists?(sender, recipient)
      # Check if sender and recipient already have conversation together.

      when_sender(sender, recipient) || when_recipient(sender, recipient)
    end

    def can_create_conversation?(sender, recipient)
      # If current sender is current recipient, return false

      class_name(sender) == class_name(recipient) && sender.id == recipient.id ? false : true
    end

    %w(sender recipient).each do |name|
      # Create when_sender and when_recipient methods, which call finder methods find_by... to fetch existing conversation.

      define_method "when_#{name}" do |sender, recipient|
        finder = Denshobato::ConversationFinder.new(sender, recipient)
        finder.send("find_by_#{name}")
      end
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
      conversation_id = form.hidden_field :denshobato_conversation_id, value: message.denshobato_conversation_id

      sender_id + sender_class + conversation_id
    end

    def interlocutor_name(user, conversation, *fields)
      # This method return text with custom fields from model, with which you've conversation

      # Retrive fields
      sender    = conversation.as_json(only: [:sender_id, :sender_class])
      recipient = conversation.as_json(only: [:recipient_id, :recipient_class])

      # Get classes by class names
      obj  = Object.const_get(recipient['recipient_class']).find(recipient['recipient_id'])
      obj2 = Object.const_get(sender['sender_class']).find(sender['sender_id'])

      return show_filter(fields, obj)  if fields.any? && user != obj
      return show_filter(fields, obj2) if fields.any? && user != obj2
    end

    def message_from(message)
      # Show information about message creator

      return unless message
      klass = Object.const_get(message.sender_class).find(message.sender_id)
      "#{klass.name} #{klass.last_name}"
    end

    private

    def show_filter(fields, obj)
      # Adds fields to View
      # h3 = "Conversation with: #{interlocutor_name(user, conversation, :first_name, :last_name)}"
      # => Conversation with John Doe

      fields.each_with_object([]) { |field, array| array << obj.send(:try, field) }.join(' ')
    end
  end
end
