require 'denshobato/version'
require 'denshobato/engine' if defined?(Rails)

# Helpers
Denshobato.autoload :HelperUtils,      'denshobato/helpers/helper_utils'
Denshobato.autoload :ViewHelper,       'denshobato/helpers/view_helper'
Denshobato.autoload :ControllerHelper, 'denshobato/helpers/controller_helper'

# View Helpers for messaging
Denshobato.autoload :ViewMessagingHelper, 'denshobato/helpers/view_messaging_helper'

# Helpers for React-Redux
Denshobato.autoload :ReactHelper, 'denshobato/helpers/react_helper'

module Denshobato
  if defined?(ActiveRecord::Base)
    require 'denshobato/extenders/core' # denshobato_for method

    # Active Record Models
    Denshobato.autoload :Conversation, 'denshobato/models/conversation'
    Denshobato.autoload :Message,      'denshobato/models/message'
    Denshobato.autoload :Notification, 'denshobato/models/notification'
    Denshobato.autoload :Blacklist,    'denshobato/models/blacklist'

    # Add helper methods to core model
    Denshobato.autoload :CoreHelper, 'denshobato/helpers/core_helper'

    ActiveRecord::Base.extend Denshobato::Extenders::Core
  end

  # Include Helpers
  ActionView::Base.include       Denshobato::ViewHelper       if defined?(ActionView::Base)
  ActionController::Base.include Denshobato::ControllerHelper if defined?(ActionController::Base)
end
