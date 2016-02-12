import React, {Component} from 'react';

export default class Message extends Component {
  render() {
    const { message, sender } = this.props;
    const cssClass = (message.sender_id == sender.senderId) ? 'left' : ' right';

    return (
      <div>
        <li className={`message ${cssClass} appeared`}>
          <div className="avatar"></div>
          <div className="text_wrapper">
            <div className="text">{message.body}</div>
          </div>
        </li>
      </div>
    );
  }
}
