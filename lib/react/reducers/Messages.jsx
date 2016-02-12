import { FETCH } from '../actions/Messages';

const messagesState = { messages: [] };

export function messages(state = messagesState, action) {
  switch (action.type) {
  case FETCH:
    return { ...state, messages: action.data };
  default:
    return state;
  }
}
