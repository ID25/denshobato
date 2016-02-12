import React, { Component } from 'react';
import store from '../store/Store';
import { connect } from 'react-redux';
import { actions } from '../actions/Index';
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

  componentDidMount() {
    let id = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
    store.dispatch(actions.messages.fetch(id));
  };

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
