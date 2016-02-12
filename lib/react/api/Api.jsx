import axios from 'axios';
const API = `${window.location.origin}/api/messages`;

export function fetch(id) {
  return axios.get(`${API}/get_conversation_messages?id=${id}`);
}
