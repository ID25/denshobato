import React, { Component } from 'react';
import store from '../store/Store';
import { actions } from '../actions/Index';

const room = document.getElementById('denshobato-message-panel');

export default class Message extends Component {
  static propTypes = {
    message: React.PropTypes.shape({
      id: React.PropTypes.number.isRequired,
      body: React.PropTypes.string.isRequired,
      sender_id: React.PropTypes.number.isRequired,
      sender_class: React.PropTypes.string.isRequired,
      avatar: React.PropTypes.string,
    }),
    sender: React.PropTypes.shape({
      senderId: React.PropTypes.number,
      conversationId: React.PropTypes.number,
      senderClass: React.PropTypes.string,
    }),
  };

  deleteMessage = () => {
    let result = confirm('Delete Message?');
    if (result) {
      store.dispatch(actions.messages.deleteMessage(this.props.message.id, room.dataset.currentUserId, room.dataset.currentUserClass));
    };
  };

  render() {
    const { message, sender } = this.props;
    const cssClass = (message.sender_id == sender.senderId) ? 'left' : 'right';

    return (
      <div>
        <li className={`message ${cssClass} appeared`}>
          <div className={`${cssClass}`}>
            <p className='name'>{`${message.full_name}`}</p>
          </div>
          <div className={`${cssClass}`}>
            <img src={message.avatar} className={`avatar ${cssClass}`}></img>
          </div>
          <div className="text_wrapper">
            <div className="text">{message.body}</div>
              {do {
                if (message.sender_id == sender.senderId) {
                  <span className='delete-message' onClick={this.deleteMessage}>X</span>;
                }
              }}
          </div>
        </li>
      </div>
    );
  }
}
