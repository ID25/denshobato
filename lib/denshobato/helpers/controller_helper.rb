module Denshobato
  module ControllerHelper
    include Denshobato::HelperUtils

    def user_in_conversation?(user, room)
      # redirect_to :root, notice: 'You can`t join this conversation unless user_in_conversation?(current_account, @conversation)'

      hato_conversation.where(id: room.id, sender: user).present? || hato_conversation.where(id: room.id, recipient: user).present?
    end

    def conversation_exists?(sender, recipient)
      # Check if sender and recipient already have conversation together.

      hato_conversation.find_by(sender: sender, recipient: recipient)
    end

    def can_create_conversation?(sender, recipient)
      # If current sender is current recipient, return false

      sender == recipient ? false : true
    end
  end
end
