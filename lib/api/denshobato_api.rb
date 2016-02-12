require 'grape'

class DenshobatoApi < Grape::API
  mount MessageApi
  mount ConversationApi
end
