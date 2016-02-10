require 'denshobato/version'
require 'denshobato/helpers/helper_utils'            # Helpers Utils

module Denshobato
  if defined?(ActiveRecord::Base)
    require 'denshobato/models/conversation'         # Active Record Conversation model.
    require 'denshobato/models/message'              # Active Record Message model.

    require 'denshobato/helpers/conversation_finder' # Conversation Finder
    require 'denshobato/helpers/denshobato_helper'   # Add helper methods to user/admin/whatever model.
    require 'denshobato/extenders/core'              # denshobato_for method.

    ActiveRecord::Base.extend Denshobato::Extenders::Core
  end

  if defined?(ActionView::Base)
    require 'denshobato/helpers/view_helper'

    ActionView::Base.include Denshobato::ViewHelper
  end
end
