require 'grape'

class MessageApi < Grape::API
  format :json
  prefix :api

  resource :messages do
    desc 'Return messages array'
    get :all_messages do
      Denshobato::Message.all.as_json
    end
  end
end
