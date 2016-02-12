import { messages } from './Messages';
import { combineReducers } from 'redux';

const Reducer = combineReducers({ messages: messages });

export default Reducer;
