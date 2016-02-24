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
    let result = confirm('Delete Message?');
    if (result) {
      store.dispatch(actions.messages.deleteMessage(this.props.message.id, this.props.sender.conversationId));
    };
  };

  render() {
    const { message, sender } = this.props;
    const cssClass = (message.author == sender.author) ? 'left' : 'right';

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
            <span className='delete-message' onClick={this.deleteMessage}>X</span>
          </div>
        </li>
      </div>
    );
  }
}
