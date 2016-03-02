module Denshobato
  module ChatPanelHelper
    # Default methods only for built-in Chat Panel
    # Override this methods, when using Chat Panel

    # class User < ActiveRecord::Base
    #  def full_name
    #    "#{first_name}", #{last_name}
    #  end
    #
    #  def image
    #    user_avatar.url
    #  end
    # end

    DEFAULT_EMAIL = 'john.doe@gmail.com'.freeze

    def full_name
      # Set up default name for chat panel
      # By default it be a class name, e.g => User

      self.class.name.titleize
    end

    def image
      # Show gravatar image
      # If model don`t have email field, which excepted by default for gravatar (and for model, which should be messagable), send to method 'default' email, to show default gravatar

      gravatar_image = Digest::MD5.hexdigest(email.downcase)
      email == DEFAULT_EMAIL ? gravatar(gravatar_image, '?d=mm') : gravatar(gravatar_image)
    end

    def method_missing(method, *_args)
      DEFAULT_EMAIL if method.to_s == 'email'
    end

    private

    def gravatar(email, args = nil)
      "https://secure.gravatar.com/avatar/#{email}/#{args}"
    end
  end
end
