import { messages } from './Messages';
import { conversation } from './Conversation';
import { combineReducers } from 'redux';
import { reducer as formReducer } from 'redux-form';

const Reducer = combineReducers({ messages: messages, conversation: conversation, form: formReducer });

export default Reducer;
