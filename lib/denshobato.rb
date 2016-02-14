require 'denshobato/version'
require 'denshobato/engine' if defined?(Rails)
# Helpers Utils
Denshobato.autoload :HelperUtils, 'denshobato/helpers/helper_utils'

# View Helpers for messaging
Denshobato.autoload :ViewMessagingHelper, 'denshobato/helpers/view_messaging_helper'

# Helpers for React-Redux
Denshobato.autoload :ReactHelper, 'denshobato/helpers/react_helper'

module Denshobato
  if defined?(ActiveRecord::Base)
    require 'denshobato/extenders/core' # denshobato_for method

    # Active Record Conversation model
    Denshobato.autoload :Conversation, 'denshobato/models/conversation'

    # Active Record Message model
    Denshobato.autoload :Message, 'denshobato/models/message'

    # Conversation Finder
    Denshobato.autoload :ConversationFinder, 'denshobato/helpers/conversation_finder'

    # Add helper methods to core model
    Denshobato.autoload :CoreHelper, 'denshobato/helpers/core_helper'

    ActiveRecord::Base.extend Denshobato::Extenders::Core
  end

  if defined?(ActionView::Base)
    # Load all view helpers
    Denshobato.autoload :ViewHelper, 'denshobato/helpers/view_helper'

    ActionView::Base.include Denshobato::ViewHelper
  end
end
