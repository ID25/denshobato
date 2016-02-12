module Denshobato
  module ViewMessagingHelper
    def interlocutor_avatar(user, image_column, conversation, css_class)
      users = conversation_interlocutors(conversation)

      return show_image(users[:sender],    css_class, image_column)  if user != users[:sender]
      return show_image(users[:recipient], css_class, image_column)  if user != users[:recipient]
    end

    def interlocutor_name(user, conversation, *fields)
      users = conversation_interlocutors(conversation)

      return show_filter(fields, users[:sender])    if fields.any? && user != users[:sender]
      return show_filter(fields, users[:recipient]) if fields.any? && user != users[:recipient]
    end

    def message_from(message)
      # Show information about message creator

      return unless message
      klass = Object.const_get(message.sender_class).find(message.sender_id)
      "#{klass.name} #{klass.last_name}"
    end

    private

    def conversation_interlocutors(conversation)
      # This method return text with custom fields from model, with which you've conversation

      # Retrive fields
      sender    = conversation.as_json(only: [:sender_id, :sender_class])
      recipient = conversation.as_json(only: [:recipient_id, :recipient_class])

      # Get classes by class names
      obj  = Object.const_get(recipient['recipient_class']).find(recipient['recipient_id'])
      obj2 = Object.const_get(sender['sender_class']).find(sender['sender_id'])
      { sender: obj, recipient: obj2 }
    end

    def show_image(user, css_class, image)
      # Show image_tag with user avatar, and css class

      image_tag(user.try(image), class: css_class)
    end

    def show_filter(fields, obj)
      # Adds fields to View
      # h3 = "Conversation with: #{interlocutor_name(user, conversation, :first_name, :last_name)}"
      # => Conversation with John Doe

      fields.each_with_object([]) { |field, array| array << obj.send(:try, field) }.join(' ')
    end
  end
end
