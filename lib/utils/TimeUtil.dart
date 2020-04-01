class TimeUtil {
  static String dateTimeFormatChatTime(int timestamp) {
    int now = DateTime.now().millisecondsSinceEpoch;
    int d = now - timestamp;
    if(d < 6000) {
      // 一分钟内
      return "刚刚";
    } else if(d < 360000) {
      // 一小时内
      return (d/6000).round().toString() + "分钟前";
    } else if(d < (360000 * 24)) {
      // 今天内
      return (d/360000).round().toString() + "小时前";
    } else {
      return "很久前";
    }
  }
}