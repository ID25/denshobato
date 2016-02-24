require 'grape'

class MessageApi < Grape::API
  format :json
  prefix :api

  helpers do
    def take_current_user(params)
      params[:class].constantize.find(params[:user])
    end

    def formated_messages(klass)
      # Prepare JSON for React

      { body: klass.body, id: klass.id, author: klass.author.email, full_name: klass.author.full_name, avatar: klass.author.image }
    end

    def send_notification(id, message)
      # Find current conversation
      conversation = densh_conversation.find(id)

      # Create Notifications
      create_notifications_for(conversation, message)
    end

    def create_notifications_for(conversation, message)
      # Take sender and recipient
      sender         = conversation.sender
      recipient      = conversation.recipient

      # Find conversation, where sender it's recipient
      conversation_2 = recipient.find_conversation_with(sender)

      # If recipient delete their conversation, create it for him
      conversation_2 = create_conversation_for_recipient(sender, recipient) if conversation_2.nil?

      # Send notifications for new messages to sender and recipient
      [conversation.id, conversation_2.id].each { |id| message.notifications.create(conversation_id: id) }
    end

    def message_class
      Denshobato::Message
    end

    def densh_conversation
      Denshobato::Conversation
    end
  end

  resource :messages do
    desc 'Return messages for current conversation'
    get :get_conversation_messages do
      # Fetch all messages from conversation

      messages = Denshobato::Conversation.find(params[:id]).messages

      messages.each_with_object([]) { |msg, arr| arr << formated_messages(msg) }
    end

    desc 'Create Message in conversation'
    post :create_message do
      # Create message in conversation

      user = params[:sender_class].constantize.find(params[:sender_id])
      message = user.hato_messages.build(body: params[:body])

      if message.save
        id = params[:conversation_id]
        send_notification(id, message)
        formated_messages(message)
      else
        error!({ error: message.errors.full_messages.join(' ') }, 422)
      end
    end

    desc 'Delete Message'
    delete :delete_message do
      # Delete message from DB

      # current_user = take_current_user(params)

      message = message_class.find(params[:id])
      conversation = params[:conversation]
      densh_conversation.where(id: conversation).includes(:denshobato_notifications).where(denshobato_notifications: { message_id: message.id }).first.notifications.first.destroy
    end
  end
end
