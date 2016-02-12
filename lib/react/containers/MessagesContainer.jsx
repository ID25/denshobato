import React, { Component } from 'react';
import store from '../store/Store';
import { connect } from 'react-redux';

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
        <h1 className='text-success'>Hello from Denshobato!</h1>
      </div>
    );
  }
}
