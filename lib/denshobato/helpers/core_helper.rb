module Denshobato
  module CoreHelper
    include Denshobato::HelperUtils         # Useful helpers
    include Denshobato::ConversationHelper  # Methods of Conversation model
    include Denshobato::MessageHelper       # Methods of Message model
    include Denshobato::BlacklistHelper     # Methods of BlackList model
  end
end
