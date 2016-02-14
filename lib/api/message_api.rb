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

      { body: klass.body, sender_id: klass.sender.id, sender_class: klass.sender.class.name, id: klass.id, avatar: klass.sender.try(:image), full_name: klass.sender.try(:full_name) }
    end

    def message_class
      Denshobato::Message
    end
  end

  resource :messages do
    desc 'Return messages for current conversation'
    get :get_conversation_messages do
      # Fetch all messages from conversation

      messages = Denshobato::Conversation.find(params[:id]).messages.select(:id, :sender_id, :body, :sender_class)

      messages.each_with_object([]) do |message, array|
        array << formated_messages(message)
      end
    end

    desc 'Create Message in conversation'
    post :create_message do
      # Create message in conversation

      message = message_class.new(body: params[:body], conversation_id: params[:conversation_id], sender_id: params[:sender_id], sender_class: params[:sender_class])

      message.save ? formated_messages(message) : error!({ error: message.errors.full_messages.join(' ') }, 422)
    end

    desc 'Delete Message'
    delete :delete_message do
      # Delete message from DB

      current_user = take_current_user(params)
      message = message_class.find(params[:id])
      if message.sender.id == current_user.id
        message.destroy
        { info: 'success' }
      else
        { info: 'error' }
      end
    end
  end
end
