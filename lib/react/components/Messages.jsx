import React, { Component } from 'react';
import store from '../store/Store';
import { actions } from '../actions/Index';
import Message from './Message';
import MessageForm from './MessageForm';
import ChatUtils from '../utils/ChatUtils';

export default class Messages extends Component {
  constructor(props) {
    super(props);
  };

  componentDidMount() {
    let id = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
    store.dispatch(actions.conversation.conversation(id));
  }

  handleSubmit = (e) => {
    const { conversation } = this.props;
    store.dispatch(actions.messages.create(e.body, conversation.senderId, conversation.conversationId, conversation.senderClass));
  };

  refreshChat = () => {
    let id = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
    store.dispatch(actions.messages.fetch(id));
  };

  render() {
    const { messages, conversation } = this.props;

    return (
      <div>
        <div className="chat_window">
          <div className="top_menu">
            <div className="buttons">
              <div className="button close" onClick={ChatUtils.closeChat}></div>
              <div className="button minimize"></div>
              <div className="button maximize"></div>
            </div>
            <div className="title">Chat</div>
            <button className='refresh-button btn' onClick={this.refreshChat}>Refresh</button>
          </div>
          <ul className="messages">
            {
              messages.map((message, index) => {
                return (
                  <div key={index}>
                    <Message message={message} sender={conversation}/>
                  </div>
                );
              })
            }
          </ul>
          <MessageForm onSubmit={this.handleSubmit}/>
        </div>
      </div>
    );
  }
}
