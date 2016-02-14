import React, { Component } from 'react';
import store from '../store/Store';
import { actions } from '../actions/Index';

export default class Message extends Component {
  deleteMessage = () => {
    let result = confirm('Delete Message?');
    if (result) {
      let room = document.getElementById('denshobato-message-panel');
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
