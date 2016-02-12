import { FETCH, CREATE } from '../actions/Messages';

const messagesState = { messages: [] };

export function messages(state = messagesState, action) {
  switch (action.type) {
  case FETCH:
    return { ...state, messages: action.data };
  case CREATE:
    let newState = state.messages.concat([action.message]);
    return { ...state, messages: newState };
  default:
    return state;
  }
}
