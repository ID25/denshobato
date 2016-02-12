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

    def class_name(klass)
      klass.class.name
    end

    def formated_messages(klass)
      { name: klass.sender.name, body: klass.body, lname: klass.sender.last_name, sender_id: klass.sender_id, sender_class: klass.sender_class, id: klass.id, avatar: klass.sender.avatar }
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

    desc 'Get info from conversation'
    get :conversation_info do
      # Get current user id, and Conversation id

      { sender_id: current_user.id, sender_class: class_name(current_user), conversation_id: Denshobato::Conversation.find(params[:id]).id }
    end

    desc 'Create Message in conversation'
    post :create_message do
      # Create message in conversation

      message = Denshobato::Message.new(body: params[:body], conversation_id: params[:conversation_id], sender_id: params[:sender_id], sender_class: params[:sender_class])

      message.save ? formated_messages(message) : error!({ error: message.errors.full_messages.join(' ') }, 422)
    end
  end
end
