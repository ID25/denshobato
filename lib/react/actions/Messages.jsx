import * as api from '../api/Api';
export const FETCH  = 'FETCH';

export function fetch(id) {
  return ((dispatch) => {
    api.fetch(id)
      .then((messages) => dispatch({ type: FETCH, data: messages.data }));
  });
}
