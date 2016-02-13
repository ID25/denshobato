import * as api from '../api/Api';
export const FETCH  = 'FETCH';
export const CREATE = 'CREATE';
export const DELETE = 'DELETE';

export function fetch(id) {
  return ((dispatch) => {
    api.fetch(id)
      .then((messages) => dispatch({ type: FETCH, data: messages.data }));
  });
}

export function create(body, sender, conversation, senderClass) {
  return ((dispatch) => {
    api.createMessage(body, sender, conversation, senderClass)
      .then((message) => dispatch({ type: CREATE, message: message.data }));
  });
}

export function deleteMessage(id) {
  return ((dispatch) => {
    api.deleteMessage(id)
      .then((response) => dispatch({ type: DELETE, data: response.data, id: id }));
  });
}
