import { CONVERSATION } from '../actions/Conversation';

const conversationState = { senderId: null, conversationId: null };

export function conversation(state = conversationState, action) {
  switch (action.type) {
  case CONVERSATION:
  console.log(action);
  return { ...state, senderId: action.response.sender_id, conversationId: action.response.conversation_id };
  default:
    return state;
  }
}
