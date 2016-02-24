module ConversationHelper
  def create_conversation(sender, recipient, other_recipient)
    sender.make_conversation_with(recipient).save
    sender.make_conversation_with(other_recipient).save

    @conversation = sender.find_conversation_with(other_recipient)
  end

  def create_msg(msg, room)
    msg.save
    msg.send_notification(room.id)
  end

  def create_conversation_and_messages
    @user.make_conversation_with(@duck).save
    @room = @user.find_conversation_with(@duck)
    @msg  = @user.send_message_to(@room.id, body: 'Hello')
    @msg2 = @duck.send_message_to(@room.id, body: 'Hi user')
    create_msg(@msg, @room)
    create_msg(@msg2, @room)
  end
end
