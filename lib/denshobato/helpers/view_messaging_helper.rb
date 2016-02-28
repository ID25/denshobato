module Denshobato
  module ViewMessagingHelper
    # OPTIMIZE: Metaprogram interlocutors methods.

    def interlocutor_avatar(user, image_column, conversation, css_class)
      sender    = conversation.sender
      recipient = conversation.recipient

      return show_image(sender,    image_column, css_class)  if user == sender
      return show_image(recipient, image_column, css_class)  if user == recipient
    end

    def interlocutor_name(user, conversation, *fields)
      sender    = conversation.sender
      recipient = conversation.recipient

      return show_filter(sender, fields)    if fields.any? && user == sender
      return show_filter(recipient, fields) if fields.any? && user == recipient
    end

    def message_from(message, *fields)
      # Show information about message creator

      return unless message
      show_filter(message.author, fields)
    end

    def interlocutor_info(klass, *fields)
      show_filter(klass, fields)
    end

    def interlocutor_image(user, column, css_class)
      show_image(user, column, css_class)
    end

    private

    def show_image(user, image, css_class)
      # Show image_tag with user avatar, and css class

      image_tag(user.try(image) || '', class: css_class)
    end

    def show_filter(klass, fields)
      # Adds fields to View
      # h3 = "Conversation with: #{interlocutor_name(user, conversation, :first_name, :last_name)}"
      # => Conversation with John Doe

      fields.each_with_object([]) { |field, array| array << klass.send(:try, field) }.join(' ').strip
    end
  end
end
