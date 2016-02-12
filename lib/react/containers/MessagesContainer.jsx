import React, { Component } from 'react';
import store from '../store/Store';
import { connect } from 'react-redux';
import Messages from '../components/Messages';

@connect((state) => {
  return {
    messages: state.messages,
  }
})

export default class MessagesContainer extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { messages } = this.props;
    console.log(messages);
    return (
      <div>
        <Messages messages={messages.messages}/>
      </div>
    );
  }
}
