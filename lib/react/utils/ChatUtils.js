export default class ChatUtils {
  static scrollChat() {
    if ($('.messages')[0] != null) {
      $('.messages').animate({ scrollTop: $('.messages')[0].scrollWidth * 999 });
    }
  };

  static closeChat () {
    $('.messages').slideToggle();
  };
};
