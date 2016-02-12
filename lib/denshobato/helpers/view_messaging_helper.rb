module Denshobato
  module ViewMessagingHelper
    def interlocutor_avatar(user, image_column, conversation, css_class)
      users = conversation_interlocutors(conversation)

      return show_image(users[:sender],    image_column, css_class)  if user != users[:sender]
      return show_image(users[:recipient], image_column, css_class)  if user != users[:recipient]
    end

    def interlocutor_name(user, conversation, *fields)
      users = conversation_interlocutors(conversation)

      return show_filter(users[:sender], fields)    if fields.any? && user != users[:sender]
      return show_filter(users[:recipient], fields) if fields.any? && user != users[:recipient]
    end

    def message_from(message, *fields)
      # Show information about message creator

      return unless message
      klass = Object.const_get(message.sender_class).find(message.sender_id)
      show_filter(klass, fields)
    end

    def interlocutor_info(klass, *fields)
      show_filter(klass, fields)
    end

    def interlocutor_image(user, column, css_class)
      show_image(user, column, css_class)
    end

    private

    def conversation_interlocutors(conversation)
      # This method return text with custom fields from model, with which you've conversation

      # Retrive fields
      sender    = conversation.as_json(only: [:sender_id, :sender_class])
      recipient = conversation.as_json(only: [:recipient_id, :recipient_class])

      # Get classes by class names
      obj  = recipient['recipient_class'].constantize.find(recipient['recipient_id'])
      obj2 = sender['sender_class'].constantize.find(sender['sender_id'])
      { sender: obj, recipient: obj2 }
    end

    def show_image(user, image, css_class)
      # Show image_tag with user avatar, and css class

      image_tag(user.try(image), class: css_class)
    end

    def show_filter(klass, fields)
      # Adds fields to View
      # h3 = "Conversation with: #{interlocutor_name(user, conversation, :first_name, :last_name)}"
      # => Conversation with John Doe

      fields.each_with_object([]) { |field, array| array << klass.send(:try, field) }.join(' ')
    end
  end
end
