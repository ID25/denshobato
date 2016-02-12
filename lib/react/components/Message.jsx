import React, {Component} from 'react';

export default class Message extends Component {
  render() {
    const { message } = this.props;

    return (
      <div>
        <li className='message left appeared'>
          <div className="avatar"></div>
          <div className="text_wrapper">
            <div className="text">{message.body}</div>
          </div>
        </li>
      </div>
    );
  }
}
