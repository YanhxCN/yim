enum MessageType {SYSTEM,PUBLIC,CHAT,GROUP}

class MessagesData {
  String avatar;
  String title;
  String subTitle;
  int time;
  MessageType type;

  MessagesData(this.avatar, this.title, this.subTitle, this.time, this.type);
}

List<MessagesData> messagesData = [
  MessagesData('http://www.17qq.com/img_qqtouxiang/80539660.jpeg',
      '妮妮',
      'I love you three thousand.',
      DateTime.now().millisecondsSinceEpoch,
      MessageType.CHAT
  ),
  MessagesData(
      'http://www.17qq.com/img_qqtouxiang/80539666.jpeg',
      '雷神',
      '展现实力，是自保的承诺',
      1585376905359,
      MessageType.CHAT
  ),
  MessagesData(
      'http://www.17qq.com/img_qqtouxiang/80539670.jpeg',
      '美队',
      '一直以来我们都在犯错，有些直到今天还在不断重演',
      1585366105000,
      MessageType.CHAT
  ),
  MessagesData(
      'http://www.17qq.com/img_qqtouxiang/80539674.jpeg',
      '绿巨人',
      '没有阴暗面的人，不值得信赖',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData(
      'http://www.17qq.com/img_qqtouxiang/80539679.jpeg',
      '黑寡妇',
      '如果我没有做到，反正我一无所有',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData(
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585383018441&di=66342138118c3e7afe40e53bf711c9d7&imgtype=0&src=http%3A%2F%2Fwww.17qq.com%2Fimg_qqtouxiang%2F80539664.jpeg',
      '绯红女巫',
      '最后你穷尽所有，上下求索，却依然一无所有！',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData(
      'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=86729633,1188613426&fm=26&gp=0.jpg',
      '黑豹',
      '黑豹',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData(
      'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1717026633,1217797692&fm=26&gp=0.jpg',
      '灭霸',
      '灭霸',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData('http://www.17qq.com/img_qqtouxiang/80539660.jpeg',
      '妮妮',
      'I love you three thousand.',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData(
      'http://www.17qq.com/img_qqtouxiang/80539666.jpeg',
      '雷神',
      '展现实力，是自保的承诺',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData(
      'http://www.17qq.com/img_qqtouxiang/80539670.jpeg',
      '美队',
      '一直以来我们都在犯错，有些直到今天还在不断重演',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData(
      'http://www.17qq.com/img_qqtouxiang/80539674.jpeg',
      '绿巨人',
      '没有阴暗面的人，不值得信赖',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData(
      'http://www.17qq.com/img_qqtouxiang/80539679.jpeg',
      '黑寡妇',
      '如果我没有做到，反正我一无所有',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData(
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1585383018441&di=66342138118c3e7afe40e53bf711c9d7&imgtype=0&src=http%3A%2F%2Fwww.17qq.com%2Fimg_qqtouxiang%2F80539664.jpeg',
      '绯红女巫',
      '最后你穷尽所有，上下求索，却依然一无所有！',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData(
      'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=86729633,1188613426&fm=26&gp=0.jpg',
      '黑豹',
      '黑豹',
      1584847705000,
      MessageType.CHAT
  ),
  MessagesData(
      'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1717026633,1217797692&fm=26&gp=0.jpg',
      '灭霸',
      '灭霸',
      1584847705000,
      MessageType.CHAT
  ),
];