import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:yim/model/message.dart';

import 'message/audio.dart';
import 'message/image.dart';
import 'message/text.dart';
import 'message/video.dart';

const int MessageLeftAlign = 1;
const int MessageRightAlign = 2;

//压缩图片，图片对flutter内存的影响很大，压缩防止崩溃
const String ImageSize = '?imageView2/2/w/200/h/200';

AudioPlayer audioPlayer = AudioPlayer();

/*
 * 单条消息
 */
class MessageItem extends StatefulWidget {
  final String avatarUrl;
  final Color color;
  final Message message;
  final int messageAlign;

  MessageItem(
      {Key key,
        this.avatarUrl,
        this.color = const Color(0xfffdd82c),
        this.message,
        this.messageAlign = MessageLeftAlign})
      : super(key: key);

  @override
  _ImMessageItemViewState createState() => _ImMessageItemViewState();
}

class _ImMessageItemViewState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    return _messageView(context);
  }

  Widget _messageView(BuildContext context) {
    if (widget.message.messageType == MessageType.text) {
      return TextMessage(
        message: widget.message,
        messageAlign: widget.messageAlign,
        color: widget.color,
        avatarUrl: widget.avatarUrl,
      );
    } else if (widget.message.messageType == MessageType.image) {
      return ImageMessage(
        message: widget.message,
        messageAlign: widget.messageAlign,
        color: widget.color,
        avatarUrl: widget.avatarUrl,
      );
    } else if (widget.message.messageType == MessageType.audio) {
      return AudioMessage(
        message: widget.message,
        messageAlign: widget.messageAlign,
        color: widget.color,
        avatarUrl: widget.avatarUrl,
      );
    } else if (widget.message.messageType == MessageType.video) {
      return VideoMessage(
        message: widget.message,
        messageAlign: widget.messageAlign,
        color: widget.color,
        avatarUrl: widget.avatarUrl,
      );
    }
    return SizedBox();
  }
}
