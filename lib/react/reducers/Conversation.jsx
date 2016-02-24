import { CONVERSATION } from '../actions/Conversation';

const conversationState = {
  author: null,
  conversationId: null,
  senderId: null,
  senderClass: null,
};

export function conversation(state = conversationState, action) {
  switch (action.type) {
  case CONVERSATION:
    let data = action.response;
    return { ...state, conversationId: data.conversation_id, author: data.author, senderId: data.sender_id, senderClass: data.sender_class };
  default:
    return state;
  }
}
