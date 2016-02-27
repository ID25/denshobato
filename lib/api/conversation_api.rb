require 'grape'

class ConversationApi < Grape::API
  format :json
  prefix :api

  helpers do
    def take_current_user(params)
      params[:class].constantize.find(params[:user])
    end

    def class_name(klass)
      klass.class.name
    end

    def conversation
      Denshobato::Conversation
    end
  end

  resource :conversations do
    desc 'Get info from conversation'
    get :conversation_info do
      # Get current user id, and Conversation id

      current_user = take_current_user(params)
      room = conversation.find(params[:id])

      { author: room.sender.email, conversation_id: room.id, sender_id: current_user.id, sender_class: class_name(current_user), recipient: room.recipient.full_name, recipient_class: class_name(room.recipient) }
    end
  end
end
