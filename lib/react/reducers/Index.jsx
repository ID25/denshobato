import { messages } from './Messages';
import { conversation } from './Conversation';
import { combineReducers } from 'redux';

const Reducer = combineReducers({ messages: messages, conversation: conversation });

export default Reducer;
