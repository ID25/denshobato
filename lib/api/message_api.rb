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
  end

  resource :messages do
    desc 'Return messages for current conversation'
    get :get_conversation_messages do
      Denshobato::Conversation.find(params[:id]).messages
    end

    desc 'Get info from conversation'
    get :conversation_info do
      { sender_id: current_user.id, conversation_id: Denshobato::Conversation.find(params[:id]).id }
    end
  end
end
