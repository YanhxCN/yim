import 'dart:ffi';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';
import 'package:yim/im/protobuf/msg.pb.dart';
import 'package:yim/im/socket_client.dart';
import 'package:yim/model/message.dart';
import 'package:yim/model/user.dart';
import 'package:yim/utils/DateUtil.dart';

import 'emoji/emoji_picker.dart';
import 'message_item.dart';
import 'voice/voice_widget.dart';


class PersonalChat extends StatefulWidget {
  final User fromUser;
  final User toUser;
  final Color color;

  PersonalChat({
    Key key,
    this.fromUser,
    this.toUser,
    this.color = const Color(0xfffdd82c)
  }) : super(key: key);

  @override
  _PersonalChatState createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  // 初始化一个FocusNode控件
  FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();

  // 控制是否显示工具栏
  bool _isShowExpanded = false;
  // 控制是否显示emoji
  bool _isShowEmoji = false;
  // 控制是否显示麦克风图标
  bool _isShowVoice = true;

  //弹起工具栏的高度
  double _expandedPanelHeight = 200;
  //添加图片滑动的距离
  double _imageScrollHeight = 220;
  //一次加载数据
  int _limit = 10;

  List<Message> _messages = [];

  List _iconButtons = [
    {'name': '相册', 'icon': Icons.photo_size_select_actual},
    {'name': '视频', 'icon': Icons.video_label},
    {'name': '拍摄', 'icon': Icons.camera_alt}
  ];

  // 只有下拉加载更多数据
  void _onRefresh() async {
    // 如果首次加载的message没有limit条表示没有历史数据，不能刷新
    if (_messages.length >= _limit) {
      Message firstMessage = _messages[0];

    } else {
      _refreshController.refreshCompleted();
    }
  }

  Widget chatRefreshHeader() {
    return ClassicHeader(
      refreshingText: "加载中...",
      idleText: "加载聊天记录",
      completeText: '加载完成',
      releaseText: '松开刷新数据',
      failedIcon: Icon(Icons.error),
      failedText: '刷新失败，请重试。',
    );
  }

  /// 发送文字消息
  void _submitMsg(String text) async {
    if (text == null || text == "") {
      return;
    }

    _textController.clear();

    Message message = Message(
        fromUser: widget.fromUser,
        toUser: widget.toUser,
        text: text,
        ioType: MessageIOType.messageIOTypeOut,
        messageType: MessageType.text);
    setState(() {
      _messages.add(message);
    });

    //发送到服务器
    Msg msg = Msg();
    Head head = Head();
    head.msgId = '1111111';
    head.msgType = 1;
    head.msgContentType = 1;
    head.fromId = '11';
    head.toId = '22';
    head.timestamp = Int64(111111111);
    msg.head = head;
    msg.body = text;
    SocketClient().sendMsg(msg);
  }

  /// 发送图片消息
  void _submitImageMsg(String path) async {
    if (path == null) {
      return;
    }

    Message message = Message(
        fromUser: widget.fromUser,
        toUser: widget.toUser,
        url: path,
        ioType: MessageIOType.messageIOTypeOut,
        messageType: MessageType.image);
    setState(() {
      _messages.add(message);
    });

    _scrollToBottom(offset: _imageScrollHeight);
    //发送到服务器
  }

  /// 发送语音消息
  void _submitVoiceMsg(String path, double duration) async {
    if (path == null) {
      return;
    }

    Message message = Message(
        fromUser: widget.fromUser,
        toUser: widget.toUser,
        url: path,
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        duration: duration.ceil(),
        ioType: MessageIOType.messageIOTypeOut,
        messageType: MessageType.audio);
    setState(() {
      _messages.add(message);
    });

    _scrollToBottom();

    //发送到服务器
  }

  /// 发送视频消息
  void _submitVideoMsg(File video) async {
    if (video == null) {
      return;
    }

    var controller = VideoPlayerController.file(video);
    await controller.initialize();
    int seconds = controller.value.duration.inSeconds;

    Message message = Message(
        fromUser: widget.fromUser,
        toUser: widget.toUser,
        url: video.path,
        duration: seconds,
        ioType: MessageIOType.messageIOTypeOut,
        messageType: MessageType.video);
    setState(() {
      _messages.add(message);
    });

    _scrollToBottom();

    //发送到服务器

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.toUser.login),
      ),
      body: Builder(builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(top: 30),
          child: Column(children: <Widget>[
            Flexible(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if(_focusNode.hasFocus) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  } else {
                    setState(() {
                      _isShowExpanded = false;
                      _isShowEmoji = false;
                    });
                  }
                },
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: chatRefreshHeader(),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    itemCount: _messages.length,
                    itemBuilder: (context,index) {
                      return _buildMessageRow(_messages[index],index);
                    }
                  ),
                ),
              ),
            ),
            Divider(height: 1.0),
            Container(
              child: _buildInputTextComposer(),
              decoration: BoxDecoration(color: Color.fromRGBO(241, 243, 244, 0.9)),
            ),
            Divider(height: 1.0),
            !_isShowEmoji
              ? SizedBox()
              : Container(
                decoration: BoxDecoration(color: Color.fromRGBO(241, 243, 244, 0.9)),
                child: _buildEmojiPanelComposer(),
              ),
            !_isShowExpanded
              ? SizedBox()
              : Container(
                height: _expandedPanelHeight,
                decoration: BoxDecoration(color: Color.fromRGBO(241, 243, 244, 0.9)),
                child: _buildExpandedPanelComposer(),
            ),
          ]),
        );
      }),
    );
  }

  Widget _buildMessageRow(Message message, int index) {
    bool isShowMessageTime = index %_limit == 0 ? true : false;
    return Column(
      children: <Widget>[
        isShowMessageTime
          ? _buildMessageTime(tranFormatTime(message.timestamp))
          : SizedBox(),
        MessageItem(
          message: message,
          avatarUrl: message.ioType == MessageIOType.messageIOTypeOut
              ? widget.fromUser.avatar_url
              : widget.toUser.avatar_url,
          messageAlign: message.ioType == MessageIOType.messageIOTypeOut
              ? MessageRightAlign
              : MessageLeftAlign,
        )
      ],
    );
  }

  Widget _buildMessageTime(String time) {
    return Container(
      alignment: Alignment.center,
      width: 100.0,
      child: Text(
        time,
        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildInputTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Color.fromRGBO(241, 243, 244, 0.9)),
      child: Container(
        alignment: Alignment.center,
        height: 40.0,
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          children: <Widget>[
            _isShowVoice
              ? GestureDetector (
                onTap: () => _openVoiceAction(context),
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Image.asset(
                    'images/voice.png',
                    height: 24,
                    width: 24,
                  ),
                ),
              )
              : GestureDetector (
                onTap: () => _openKeyboardAction(context),
                child: Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: Image.asset(
                    'images/keyboard.png',
                    height: 28,
                    width: 28,
                  ),
                ),
              ),
            _isShowVoice
              ? Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 2,bottom: 2),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    controller: _textController,
                    focusNode: _focusNode,
                    onSubmitted: _submitMsg,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      )
                    ),
                  ),
                ),
              )
              : Expanded(
                child: VoiceWidget(
                  startRecord: () {},
                  stopRecord: (path, length) {
                    _submitVoiceMsg(path, length);
                  },
                ),
              ),
            GestureDetector(
              onTap: () => _openEmojiAction(context),
              child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Image.asset('images/emoji.png',
                      height: 29, width: 29, color: Colors.black)),
            ),
            GestureDetector(
              onTap: () => _openExpandedAction(context),
              child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Image.asset('images/more.png',
                      height: 24, width: 24, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiPanelComposer() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      recommendKeywords: ["racing", "horse"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        _textController.text = _textController.text + emoji.emoji;
      },
    );
  }

  Widget _buildExpandedPanelComposer() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 40.0,
            childAspectRatio: 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        scrollDirection: Axis.vertical,
        itemCount: _iconButtons.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildIconButton(
              _iconButtons[index]['name'], _iconButtons[index]['icon']);
        });
  }

  Widget _buildIconButton(String buttonName, IconData icon) {
    return Column(
      children: <Widget>[
        GestureDetector(
          excludeFromSemantics: true,
          onTap: () {
            _openExpandedIcon(buttonName);
          },
          child: Container(
            width: 60.0,
            height: 60.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            child: Icon(
              icon,
              size: 28.0,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 3.0),
            child: Text(buttonName,
                style: TextStyle(fontSize: 12.0, color: Colors.grey[600])))
      ],
    );
  }

  void _openExpandedIcon(String iconName) async {
    if (iconName == '相册') {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      _submitImageMsg(image.path);
    } else if (iconName == '视频') {
      var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
      _submitVideoMsg(video);
    } else if (iconName == '拍摄') {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      _submitImageMsg(image.path);
    }
  }

  /// 点击语音图标
  void _openVoiceAction(BuildContext context) {
    _isShowExpanded = false;
    _isShowEmoji = false;
    _isShowVoice = false;
    if (_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(FocusNode());
    }

    setState(() {});
  }

  /// 点击键盘图标
  void _openKeyboardAction(BuildContext context) {
    _isShowExpanded = false;
    _isShowEmoji = false;
    _isShowVoice = true;

    setState(() {});

    Future.delayed(Duration(milliseconds: 100), () {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  /// 点击Emoji图标
  void _openEmojiAction(BuildContext context) {
    if (_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(FocusNode());

      //Focus和setState冲突，延迟执行setState
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          _isShowEmoji = !_isShowEmoji;
          _isShowExpanded = false;
          _isShowVoice = true;
          _scrollToBottom();
        });
      });
    } else {
      setState(() {
        _isShowEmoji = !_isShowEmoji;
        _isShowExpanded = false;
        _isShowVoice = true;
        _scrollToBottom();
      });
    }
  }

  /// 点击 + 图标
  void _openExpandedAction(BuildContext context) {
    if (_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(FocusNode());

      //Focus和setState冲突，延迟执行setState
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          _isShowExpanded = !_isShowExpanded;
          _isShowEmoji = false;
          _isShowVoice = false;
          _scrollToBottom();
        });
      });
    } else {
      setState(() {
        _isShowExpanded = !_isShowExpanded;
        _isShowEmoji = false;
        _isShowVoice = false;
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom({double offset = 0, int milliseconds = 100}) {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + offset,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }
}