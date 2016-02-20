module Denshobato
  module ControllerHelper
    include Denshobato::HelperUtils

    def user_in_conversation?(room)
      # redirect_to :root, notice: 'You can`t join this conversation unless user_in_conversation?(@conversation)'

      conversation.where(id: room.id, sender: current_account).present? || conversation.where(id: room.id, recipient: current_account).present?
    end

    def conversation_exists?(sender, recipient)
      # Check if sender and recipient already have conversation together.

      conversation.find_by(sender: sender, recipient: recipient)
    end

    def can_create_conversation?(sender, recipient)
      # If current sender is current recipient, return false

      sender == recipient ? false : true
    end
  end
end
