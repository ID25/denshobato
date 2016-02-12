require 'denshobato/version'
require 'denshobato/engine'
require 'denshobato/helpers/helper_utils'            # Helpers Utils
require 'denshobato/helpers/view_messaging_helper'   # View Helpers for messaging

module Denshobato
  if defined?(ActiveRecord::Base)
    require 'denshobato/models/conversation'         # Active Record Conversation model
    require 'denshobato/models/message'              # Active Record Message model

    require 'denshobato/helpers/conversation_finder' # Conversation Finder
    require 'denshobato/helpers/core_helper'         # Add helper methods to core model
    require 'denshobato/extenders/core'              # denshobato_for method

    ActiveRecord::Base.extend Denshobato::Extenders::Core
  end

  if defined?(ActionView::Base)
    require 'denshobato/helpers/view_helper'

    ActionView::Base.include Denshobato::ViewHelper
  end
end
