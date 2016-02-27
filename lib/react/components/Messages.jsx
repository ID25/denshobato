import React, { Component } from 'react';
import store from '../store/Store';
import { actions } from '../actions/Index';
import Message from './Message';
import { reset } from 'redux-form';
import MessageForm from './MessageForm';
import ChatUtils from '../utils/ChatUtils';

const room = document.getElementById('denshobato-message-panel');

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
    store.dispatch(actions.conversation.conversation(room.dataset.room, room.dataset.currentUserId, room.dataset.currentUserClass));
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.messages.length != this.props.messages.length) {
      this.refreshChat();
    }
  }

  handleSubmit = (e) => {
    const { conversation } = this.props;
    this.refreshChat();
    store.dispatch(actions.messages.create(e.body, conversation.senderId, conversation.conversationId, conversation.senderClass));
    store.dispatch(reset('message-form'));
  };

  refreshChat = () => {
    store.dispatch(actions.messages.fetch(room.dataset.room));
  };

  showAll = () => {
    store.dispatch(actions.messages.showAll());
  };

  render() {
    const { messages, conversation, showAll } = this.props;

    return (
      <div>
        <div className="top_menu">
          <div className="buttons">
            <div className="button close-button" onClick={ChatUtils.closeChat}></div>
            <div className="button minimize"></div>
            <div className="button maximize"></div>
          </div>
          <div className="title">
            <div className="chat-header">
              <div className="header-description">
                <p>
                  {`Chat with ${conversation.recipient}`}
                </p>
              </div>
            </div>
          </div>
          <button className="refresh-button btn" onClick={this.refreshChat}>Refresh</button>
        </div>
        <div className='chat-wrapper'>
          <div className='chat-message padding'>
            { do {
              if (messages.length >= 50 && !showAll) {
                <div className='text-center'>
                  <button className='load-messages' onClick={this.showAll}>Load previous messages</button>
                </div>;
              }
            } }

            {/* TODO: Refactoring this condition. */}
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
            <MessageForm onSubmit={this.handleSubmit}/>
          </div>
        </div>
      </div>
    );
  }
}
