require 'denshobato/version'

module Denshobato
  if defined?(ActiveRecord::Base)
    require 'denshobato/models/conversation' # Active Record Conversation model.
    require 'denshobato/models/message'      # Active Record Message model.

    require 'denshobato/helpers/sender_helper' # Add helper methods to current_user/admin/whatever model.
    require 'denshobato/extenders/core'        # denshobato_for method.

    ActiveRecord::Base.extend Denshobato::Extenders::Core
  end
end
