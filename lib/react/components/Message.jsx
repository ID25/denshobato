import React, { Component } from 'react';
import store from '../store/Store';
import { actions } from '../actions/Index';

const room = document.getElementById('denshobato-message-panel');

export default class Message extends Component {
  static propTypes = {
    message: React.PropTypes.shape({
      id: React.PropTypes.number.isRequired,
      body: React.PropTypes.string.isRequired,
      author: React.PropTypes.string.isRequired,
    }),
    sender: React.PropTypes.shape({
      author: React.PropTypes.string,
      conversationId: React.PropTypes.number,
    }),
  };

  deleteMessage = () => {
    let result = confirm('Delete Message from your conversation?');
    if (result) {
      store.dispatch(actions.messages.deleteMessage(this.props.message.id, this.props.sender.conversationId));
    };
  };

  render() {
    const { message, sender } = this.props;
    const cssClass = (message.author == sender.author) ? 'recipient' : 'sender';

    return (
      <div className={`chat-message chat-message-${cssClass}`}>
        <span className='message-author'>{message.full_name}</span>
        <img className='chat-image chat-image-default' src={message.avatar} />
        <span className='message-time'>{message.time}</span>
        <div className='chat-message-wrapper'>
          <div className='chat-message-content'>
            <p>{message.body}</p>
          </div>
          <div className='chat-details'>
            <span className='chat-message-localization font-size-small' onClick={this.deleteMessage}>Remove</span>
          </div>
        </div>
      </div>
    );
  }
}
