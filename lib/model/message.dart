import 'dart:convert';
import 'package:yim/model/user.dart';

class MessageType {
  static const int text = -1;
  static const int image = -2;
  static const int audio = -3;
  static const int video = -4;
  static const int location = -5;
  static const int file = -6;
}

class MessageIOType {
  static const int messageIOTypeIn = 1;
  static const int messageIOTypeOut = 2;
}

class Messages {
  final List<Message> messages;
  Messages({this.messages});

  factory Messages.fromJson(List<dynamic> parsedJson) {
    List<Message> messages = List<Message>();
    messages = parsedJson.map((i) => Message.fromJson(i)).toList();
    return Messages(messages: messages);
  }
}

class Message {
  final String conversationId;
  final String messageId;
  final User fromUser;
  final User toUser;
  final String text;
  final String url;
  String thumbnailUrl;
  final int timestamp;
  final int messageType;
  final int ioType;
  final int duration;
  final Map<String, dynamic>
  attributes; // 如果最后一条消息是当前用户，则attributes中包含用户的姓名，否则为空
  Message(
      {this.messageId,
        this.conversationId,
        this.fromUser,
        this.toUser,
        this.text,
        this.url,
        this.duration,
        this.ioType,
        this.timestamp,
        this.attributes,
        this.messageType});

  //用于获取消息记录
  factory Message.fromJson(Map<dynamic, dynamic> jsonMap) {
    Map contentMap = json.decode(jsonMap['content']);
    String url = "";
    int duration = 0;
    if (contentMap['_lctype'] < MessageType.text) {
      url = contentMap['_lcfile']['url'];
      if (contentMap['_lcfile']['metaData'] != null) {
        if (contentMap['_lcfile']['metaData']['duration'] != null) {
          duration = double.parse(contentMap['_lcfile']['metaData']['duration'].toString())
              .ceil();
        }
      }
    }
    return Message(
        conversationId: jsonMap['conversationId'],
        messageId: jsonMap['messageId'],
        ioType: jsonMap['ioType'],
        messageType: contentMap['_lctype'],
        text: contentMap['_lctext'],
        url: url,
        duration: duration,
        timestamp: jsonMap['timestamp'] ?? 0);
  }

  // 用于convetsation中读取lastMessage
  factory Message.fromString(String value) {
    Map valueMap = json.decode(value);
    String text = "";
    if (valueMap['_lctype'] == MessageType.text) {
      text = valueMap['_lctext'];
    } else if (valueMap['_lctype'] == MessageType.image) {
      text = '[图片]';
    } else if (valueMap['_lctype'] == MessageType.audio) {
      text = '[语音]';
    } else if (valueMap['_lctype'] == MessageType.video) {
      text = '[视频]';
    }
    return Message(
      conversationId: valueMap['conversationId'],
      messageId: valueMap['messageId'],
      messageType: valueMap['_lctype'],
      text: text,
      attributes: valueMap['_lcattrs'],
    );
  }
}
