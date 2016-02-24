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
      { author: current_user.email, conversation_id: conversation.find(params[:id]).id, sender_id: current_user.id, sender_class: class_name(current_user) }
    end
  end
end
