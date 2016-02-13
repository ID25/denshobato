import React from 'react';
import { render } from 'react-dom';
import { Provider, connect } from 'react-redux';
import MessagesContainer from './containers/MessagesContainer';
import store from './store/Store';

window.onload = (() => {
  const domNode  = document.getElementById('denshobato-message-panel');

  if (domNode !=  null) {
    render(
      <Provider store={store}>
        <MessagesContainer/>
      </Provider>,
      domNode
    );
  }
});
