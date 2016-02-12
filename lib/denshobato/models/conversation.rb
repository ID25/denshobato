module Denshobato
  class Conversation < ::ActiveRecord::Base
    self.table_name = 'denshobato_conversations'

    # Has many messages
    has_many :denshobato_messages, class_name: '::Denshobato::Message', dependent: :destroy, inverse_of: :denshobato_conversation

    # Validate fields
    validates         :recipient_id, :sender_id, presence: { message: 'can`t be empty' }
    validate          :conversation_uniqueness
    before_validation :check_sender # sender can't create conversations with yourself.

    # Fetch conversations for current_user/admin/duck/customer/whatever model.
    scope :conversations_for, -> (user) { where('sender_id = ? AND sender_class = ? or recipient_id = ? AND recipient_class = ?', user, user.class.name, user, user.class.name).order(updated_at: :desc) }

    alias messages denshobato_messages

    private

    def check_sender
      errors.add(:conversation, 'You can`t create conversation with yourself') if (sender_class == recipient_class) && (sender_id == recipient_id)
    end

    def conversation_uniqueness
      # Checking conversation for uniqueness, when recipient is sender, and vice versa.
      columns.each do |first, second, third, fourth|
        if Conversation.where(sender_id: first, sender_class: second, recipient_id: third, recipient_class: fourth).present?
          errors.add(:conversation, 'You already have conversation with this user.')
        end
      end
    end

    def columns
      [[sender_id, sender_class, recipient_id, recipient_class], [recipient_id, recipient_class, sender_id, sender_class]]
    end
  end
end
