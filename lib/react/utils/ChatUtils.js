export default class ChatUtils {
  static scrollChat() {
    let messages = document.getElementsByClassName('messages')[0];
    if (messages != null) {
      $(messages).animate({ scrollTop: messages.scrollWidth * 999 });
    };
  };

  static closeChat () {
    $('.messages').slideToggle();
  };
};
