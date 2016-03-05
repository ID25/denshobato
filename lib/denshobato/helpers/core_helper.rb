module Denshobato
  module CoreHelper
    include Denshobato::HelperUtils         # Useful helpers
    include Denshobato::ConversationHelper  # Methods of Conversation model
    include Denshobato::MessageHelper       # Methods of Message model
    include Denshobato::BlacklistHelper     # Methods of BlackList model

    # Methods for chat panel (json api)
    # gem 'denshobato_chat_panel'
    include Denshobato::ChatPanelHelper if defined?(DenshobatoChatPanel)
  end
end
