import React, { Component } from 'react';
import store from '../store/Store';
import { actions } from '../actions/Index';
import Message from './Message';
import { reset } from 'redux-form';
import MessageForm from './MessageForm';
import ChatUtils from '../utils/ChatUtils';

export default class Messages extends Component {
  static propTypes = {
    conversation: React.PropTypes.shape({
      senderId: React.PropTypes.number,
      conversationId: React.PropTypes.number,
      senderClass: React.PropTypes.string,
    }),
    showAll: React.PropTypes.bool.isRequired,
    messages: React.PropTypes.arrayOf(React.PropTypes.object),
  };

  constructor(props) {
    super(props);
  };

  componentDidMount() {
    let room = document.getElementById('denshobato-message-panel');
    store.dispatch(actions.conversation.conversation(room.dataset.room, room.dataset.currentUserId, room.dataset.currentUserClass));
  }

  handleSubmit = (e) => {
    const { conversation } = this.props;
    store.dispatch(actions.messages.create(e.body, conversation.senderId, conversation.conversationId, conversation.senderClass));
    store.dispatch(reset('message-form'));
  };

  refreshChat = () => {
    let id = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
    store.dispatch(actions.messages.fetch(id));
  };

  showAll = () => {
    store.dispatch(actions.messages.showAll());
  };

  render() {
    const { messages, conversation, showAll } = this.props;

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
            { do {
              if (messages.length >= 50 && !showAll) {
                <div className='text-center'>
                  <button className='load-messages' onClick={this.showAll}>Load previous messages</button>
                </div>;
              }
            } }

            { do {

              if (messages.length >= 50 && !showAll) {
                messages.slice(Math.max(messages.length - 50, 1)).map((message, index) => {
                  return (
                    <div key={index}>
                      <Message message={message} sender={conversation}/>
                    </div>
                  );
                });
              } else {
                messages.map((message, index) => {
                  return (
                    <div key={index}>
                      <Message message={message} sender={conversation}/>
                    </div>
                  );
                });
              }
            }
            }
          </ul>
          <MessageForm onSubmit={this.handleSubmit}/>
        </div>
      </div>
    );
  }
}
