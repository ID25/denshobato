export default class ChatUtils {
  static scrollChat() {
    let messages = document.getElementsByClassName('chat-wrapper')[0];
    if (messages != null) {
      $(messages).animate({ scrollTop: messages.scrollWidth * 999 });
    };
  };

  static closeChat () {
    $('.chat-message').slideToggle();
  };
};
