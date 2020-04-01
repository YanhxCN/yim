import 'package:flutter/material.dart';
import 'package:yim/messages/messages_data.dart';
import 'package:yim/utils/TimeUtil.dart';
import 'package:yim/widget/tap_callback.dart';

class MessagesItem extends StatelessWidget {

  final MessagesData _msgData;

  MessagesItem(this._msgData);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: .5, color: Color(0xFFD9D9D9))
        ),
      ),
      child: TapCallback(
        onPressed: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, //垂直居中
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 13.0, right: 13.0),
              child: Image.network(_msgData.avatar, width: 48.0, height: 48.0),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _msgData.title,
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF353535)),
                    maxLines: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                  ),
                  Text(
                    _msgData.subTitle,
                    style: TextStyle(fontSize: 14.0, color: Color(0xFFa9a9a9)),
                    maxLines: 1,
                    // 显示不完的文本用省略号来表示
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: const EdgeInsets.only(right: 12.0, top: 12.0),
              child: Text(
                TimeUtil.dateTimeFormatChatTime(_msgData.time),
                style: TextStyle(fontSize: 14.0,color: Color(0xFFa9a9a9)),
              ),
            ),
          ],
        ),
      ),
    );
  }

}