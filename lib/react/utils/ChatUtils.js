export default class ChatUtils {
  static scrollChat() {
    $('.messages').animate({ scrollTop: $('.messages')[0].scrollWidth }, 500);
  };
};
