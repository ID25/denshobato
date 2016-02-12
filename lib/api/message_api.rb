require 'grape'

class MessageApi < Grape::API
  format :json
  prefix :api

  resource :messages do
    desc 'Return messages for current conversation'
    get :get_conversation_messages do
      Denshobato::Conversation.find(params[:id]).messages
    end
  end
end
