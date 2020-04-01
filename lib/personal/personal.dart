import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yim/common/global.dart';
import 'package:yim/widget/im_item.dart';
import 'package:yim/widget/tap_callback.dart';

class Personal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //列表
      body: ListView(
        children: <Widget>[
          //头像部分实现
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            color: Colors.white,
            height: 80.0,
            child: TapCallback(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //添加头像
                  Container(
                    margin: const EdgeInsets.only(left: 12.0, right: 15.0),
                    child: gmAvatar(Global.profile.user.avatar_url, width: 80),
                  ),
                  //用户名及帐号显示
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Global.profile.user.login,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Color(0xFF353535),
                          ),
                        ),
                        Text(
                          'ID: '+Global.profile.user.id.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFFa9a9a9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //二维码图片显示
                  Container(
                    margin: const EdgeInsets.only(left: 12.0, right: 15.0),
                    child: Image.asset(
                      'images/ic_code.png',
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                ],
              ),
              onPressed: () {Navigator.pushNamed(context, "personalInfo");},
            ),
          ),
          //列表项 使用ImItem渲染
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            color: Colors.white,
            child: ImItem(
              title: '好友动态',
              imagePath: 'images/ic_me_friends.png',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ImItem(
                  imagePath: 'images/ic_me_message.png',
                  title: '消息管理',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(
                    height: 0.5,
                    color: Color(0xFFd9d9d9),
                  ),
                ),
                ImItem(
                  imagePath: 'images/ic_me_photo.png',
                  title: '我的相册',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(
                    height: 0.5,
                    color: Color(0xFFd9d9d9),
                  ),
                ),
                ImItem(
                  imagePath: 'images/ic_me_file.png',
                  title: '我的文件',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(
                    height: 0.5,
                    color: Color(0xFFd9d9d9),
                  ),
                ),
                ImItem(
                  imagePath: 'images/ic_me_service.png',
                  title: '联系客服',
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            color: Colors.white,
            child: ImItem(
              title: '清理缓存',
              imagePath: 'images/ic_me_clear.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget gmAvatar(String url, {
    double width = 30,
    double height,
    BoxFit fit,
    BorderRadius borderRadius,
  }) {
    var placeholder = Image.asset(
      "images/ironman.jpg", //头像占位图，加载过程中显示
      width: width,
      height: height,
    );
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(2),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
      ),
    );
  }
}