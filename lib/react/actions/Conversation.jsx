import * as api from '../api/Api';
export const CONVERSATION  = 'CONVERSATION';

export function conversation(id) {
  return ((dispatch) => {
    api.conversation(id)
      .then((response) => dispatch({ type: CONVERSATION, response: response.data }));
  });
}
