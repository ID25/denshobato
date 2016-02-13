import { FETCH, CREATE, DELETE, SHOW_ALL } from '../actions/Messages';

const messagesState = { messages: [], loaded: false, showAll: false };

export function messages(state = messagesState, action) {
  switch (action.type) {
  case FETCH:
    return { ...state, messages: action.data, loaded: true };
  case CREATE:
    let newState = state.messages.concat([action.message]);
    return { ...state, messages: newState };
  case DELETE:
    let index = state.messages.map((x) => x.id).indexOf(action.id);
    state.messages.splice(index, 1);
    return { ...state, messages: state.messages };
  case SHOW_ALL:
    return { ...state, showAll: action.data };
  default:
    return state;
  }
}
