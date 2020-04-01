import 'dart:io';
import 'dart:typed_data';

import 'protobuf/msg.pb.dart';

///消息长度用2个字节描述
const int msgByteLen = 2;

///消息号用2个字节描述
const int msgCodeByteLen = 2;

///最小的消息长度为4个字节（即消息长度+消息号）
const int minMsgByteLen = msgByteLen + msgCodeByteLen;

class SocketClient {
  //地址
  static const String host = '192.168.31.235';
  //端口
  static const int port = 5555;
  // Socket示例
  Socket _socket;
  // 数据接收组
  var _recList;

  // 单例方法
  static SocketClient _instance;

  static SocketClient get instance => _getInstance();

  factory SocketClient() => _getInstance();

  static SocketClient _getInstance() {
    if (_instance == null) {
      _instance = new SocketClient._internal();
    }
    return _instance;
  }

  SocketClient._internal() {
    print('SocketClient初始化');
    // 初始化
    startClient();
  }

  Future<Null> startClient() async {
    print('连接服务器中 ...');
    // 初始化接收组
    _recList = new List<int>();
    // 建立连接
    _socket = await Socket.connect(host, port);
    // 添加数据监听
    _socket.listen((data) {
      // 接收数据并处理
      List dataList = Int8List.fromList(data);
      // 接收后处理
      readData(dataList);
    });
  }

  void sendMsg(Msg pb) {
    //序列化pb对象
    Uint8List pbBody;
    int pbLen = 0;
    if(pb != null) {
      pbBody = pb.writeToBuffer();
      pbLen = pbBody.length;
    }

    //包头部分
    var header = ByteData(minMsgByteLen);
    header.setInt16(0, msgCodeByteLen + pbLen);
    header.setInt16(msgByteLen, 111);

    //包头+pb组合成一个完整的数据包
    var msg = pbBody.buffer.asUint8List();

    //给服务器发消息
    try {
      _socket.add(msg);
      _socket.flush();
      print("给服务端发送消息，消息号=111");
    } catch (e) {
      print("send捕获异常：msgCode=111，e=${e.toString()}");
    }
  }

  void readData(List dataList) {
    // 从二进制数据获取模型
    Msg msg = Msg.fromBuffer(dataList);
  }

}