import React, { Component } from 'react';
import store from '../store/Store';
import Message from './Message';

export default class Messages extends Component {
  constructor(props) {
    super(props);
  };

  render() {
    const { messages } = this.props;

    return (
      <div>
        <div className="chat_window">
          <div className="top_menu">
            <div className="buttons">
              <div className="button close" ></div>
              <div className="button minimize"></div>
              <div className="button maximize"></div>
            </div>
            <div className="title">Chat</div>
          </div>
          <ul className="messages">
            {
              messages.map((message, index) => {
                return (
                  <div key={index}>
                    <Message message={message}/>
                  </div>
                );
              })
            }
          </ul>
        </div>
      </div>
    );
  }
}
