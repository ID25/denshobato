require 'denshobato/version'

module Denshobato
  if defined?(ActiveRecord::Base)
    require 'denshobato/conversation'   # Active Record Conversation model.
    require 'denshobato/extenders/core' # denshobato_for method.

    ActiveRecord::Base.extend Denshobato::Extenders::Core
  end
end
