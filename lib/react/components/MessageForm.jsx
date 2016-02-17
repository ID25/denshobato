import React, { Component } from 'react';
import { reduxForm } from 'redux-form';
import store from '../store/Store';

export default class MessageForm extends Component {
  static propTypes = {
    handleSubmit: React.PropTypes.func.isRequired,
    fields: React.PropTypes.shape({
      body: React.PropTypes.object.isRequired,
      senderClass: React.PropTypes.object.isRequired,
    }),
  };

  render() {
    const { fields: { body, senderClass }, handleSubmit } = this.props;
    return (
      <div>
        <form onSubmit={handleSubmit}>
          <div className="bottom_wrapper clearfix">
            <div className="message_input_wrapper">
              <input className="message_input" placeholder="Type your message here..." {...body}/>
              </div>
            <div className="send_message">
              <div className="icon"></div>
              <button onclick={handleSubmit} className="text">Send</button>
            </div>
          </div>
      </form>
      </div>
    );
  }
}

MessageForm = reduxForm({
  form: 'message-form',
  fields: ['body', 'senderClass'],
})(MessageForm);
