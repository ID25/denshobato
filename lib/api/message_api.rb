require 'grape'

class MessageApi < Grape::API
  format :json
  prefix :api

  helpers do
    def current_user
      # For now, handle only devise

      id = env['rack.session']['warden.user.user.key'].first.first
      User.find(id)
    end

    def formated_messages(klass)
      # Prepare JSON for React

      { name: klass.sender.name, body: klass.body, lname: klass.sender.last_name, sender_id: klass.sender_id, sender_class: klass.sender_class, id: klass.id, avatar: klass.sender.avatar }
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
