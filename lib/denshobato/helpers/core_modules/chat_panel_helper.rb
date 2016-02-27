module Denshobato
  module ChatPanelHelper
    # Default methods only for built-in Chat Panel

    def full_name
      # Set up default name for chat panel
      # By default it be a class name, e.g => User

      self.class.name.titleize
    end

    def image
      # Set up default avatar in chat panel
      # TODO: Generate random image e.g first letter on name, or email

      'http://i.imgur.com/pGHOaLg.png'
    end
  end
end
