import { FETCH, CREATE, DELETE } from '../actions/Messages';

const messagesState = { messages: [] };

export function messages(state = messagesState, action) {
  switch (action.type) {
  case FETCH:
    return { ...state, messages: action.data };
  case CREATE:
    let newState = state.messages.concat([action.message]);
    return { ...state, messages: newState };
  case DELETE:
    let index = state.messages.map((x) => x.id).indexOf(action.id);
    state.messages.splice(index, 1);
    return { ...state, messages: state.messages };
  default:
    return state;
  }
}
