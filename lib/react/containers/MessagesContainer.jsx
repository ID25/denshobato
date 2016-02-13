import React, { Component } from 'react';
import store from '../store/Store';
import { connect } from 'react-redux';
import { actions } from '../actions/Index';
import Messages from '../components/Messages';
import ChatUtils from '../utils/ChatUtils';

@connect((state) => {
  return {
    messages: state.messages,
    conversation: state.conversation,
  }
})

export default class MessagesContainer extends Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    let id = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
    store.dispatch(actions.messages.fetch(id));
  };

  componentWillReceiveProps(nextProps) {
    if (nextProps.messages.length != this.props.messages.messages.length) {
      ChatUtils.scrollChat();
    }
  }

  render() {
    const { messages, conversation } = this.props;
    return (
      <div>
        {do {
          if (!messages.loaded) {
            <div className="loading">
              <p>LOADING MESSAGES...</p>
            </div>;
          } else {
            <Messages messages={messages.messages} conversation={conversation} showAll={messages.showAll}/>;
          }
        }}
      </div>
    );
  }
}
