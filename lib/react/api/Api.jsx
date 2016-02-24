import axios from 'axios';
const API = `${window.location.origin}/api`;

export function fetch(id) {
  return axios.get(`${API}/messages/get_conversation_messages?id=${id}`);
}

export function conversation(id, user, klass) {
  return axios.get(`${API}/conversations/conversation_info?id=${id}&user=${user}&class=${klass}`);
}

export function createMessage(body, sender, conversation, senderClass) {
  return axios.post(`${API}/messages/create_message?body=${body}&conversation_id=${conversation}&sender_id=${sender}&sender_class=${senderClass}`);
}

export function deleteMessage(id, conversation) {
  return axios.delete(`${API}/messages/delete_message?id=${id}&conversation=${conversation}`);
}
