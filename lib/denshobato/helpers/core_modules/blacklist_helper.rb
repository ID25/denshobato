module Denshobato
  module BlacklistHelper
    def add_to_blacklist(user)
      # Add user to blacklist
      # User can`t create conversation, and can`t send message to blocker model

      blacklist.build(blocked: user)
    end

    def remove_from_blacklist(user)
      # Removeu user from blacklist

      hato_blacklist.find_by(blocker: self, blocked: user)
    end

    def my_blacklist
      # Show blocked users

      blacklist.includes(:blocked)
    end
  end
end
