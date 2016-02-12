import * as api from '../api/Api';
export const FETCH  = 'FETCH';
export const CREATE = 'CREATE';

export function fetch(id) {
  return ((dispatch) => {
    api.fetch(id)
      .then((messages) => dispatch({ type: FETCH, data: messages.data }));
  });
}

export function create(body, sender, conversation) {
  return ((dispatch) => {
    api.createMessage(body, sender, conversation)
      .then((message) => dispatch({ type: CREATE, message: message.data }));
  });
}
