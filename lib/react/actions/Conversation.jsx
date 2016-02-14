import * as api from '../api/Api';
export const CONVERSATION  = 'CONVERSATION';

export function conversation(id, user, klass) {
  return ((dispatch) => {
    api.conversation(id, user, klass)
      .then((response) => dispatch({ type: CONVERSATION, response: response.data }));
  });
}
