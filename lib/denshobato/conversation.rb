module Denshobato
  class Conversation < ::ActiveRecord::Base
    self.table_name = 'denshobato_conversations'

    # Validate fields
    validates :recipient_id, :sender_id, presence: { message: 'can`t be empty' }
    validate  :conversation_uniqueness

    # Fetch conversations for current_user/admin/duck/customer/whatever model.
    scope :conversations_for, -> (user) { where('sender_id = ? or recipient_id = ?', user, user) }

    private

    def conversation_uniqueness
      # Checking conversation for uniqueness, when recipient is sender, and vice versa.

      [[sender_id, recipient_id], [recipient_id, sender_id]].each do |column, kolumn|
        errors.add(:conversation, 'You already have conversation with this user.') if Conversation.where(sender_id: column, recipient_id: kolumn).present?
      end
    end
  end
end
