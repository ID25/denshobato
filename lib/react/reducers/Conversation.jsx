import { CONVERSATION } from '../actions/Conversation';

const conversationState = {
  senderId: null,
  conversationId: null,
  senderClass: null,
};

export function conversation(state = conversationState, action) {
  switch (action.type) {
  case CONVERSATION:
    let data = action.response;
    return { ...state, senderId: data.sender_id, conversationId: data.conversation_id, senderClass: data.sender_class };
  default:
    return state;
  }
}
