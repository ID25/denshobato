require 'grape'

class ConversationApi < Grape::API
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
  end

  resource :conversations do
    desc 'Get info from conversation'
    get :conversation_info do
      # Get current user id, and Conversation id

      { sender_id: current_user.id, sender_class: class_name(current_user), conversation_id: Denshobato::Conversation.find(params[:id]).id }
    end
  end
end
