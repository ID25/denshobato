export default class ChatUtils {
  static scrollChat() {
    $('.messages').animate({ scrollTop: $('.messages')[0].scrollWidth }, 500);
  };

  static refreshChat() {
    let id = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
    store.dispatch(actions.messages.fetch(id));
  };

  static closeChat () {
    $('.messages').slideToggle();
  };
};
