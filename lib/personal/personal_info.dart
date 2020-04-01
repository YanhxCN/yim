import 'package:flutter/material.dart';
import 'package:yim/widget/tap_callback.dart';

class PersonalInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人信息'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 20.0),
            color: Colors.white,
            height: 80.0,
            child: TapCallback(
              onPressed: () {Navigator.of(context).pushNamed('personalSet',arguments: '个人头像');},
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child:  Text('头像',style: TextStyle(color: Colors.black,fontSize: 17.0)),
                  ),
                  Image.asset(
                    'images/ironman.jpg',
                    width: 70.0,
                    height: 70.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top:20.0, left: 20.0),
            color: Colors.white,
            child: TapCallback(
              onPressed: () {Navigator.of(context).pushNamed('personalSet',arguments: '设置名字');},
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child:  Text('名字',style: TextStyle(color: Colors.black,fontSize: 17.0)),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top:20.0, left: 20.0),
            color: Colors.white,
            child: TapCallback(
              onPressed: () {},
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child:  Text('ID',style: TextStyle(color: Colors.black,fontSize: 17.0)),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top:20.0, left: 20.0),
            color: Colors.white,
            child: TapCallback(
              onPressed: () {Navigator.of(context).pushNamed('personalSet',arguments: '我的二维码');},
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child:  Text('我的二维码',style: TextStyle(color: Colors.black,fontSize: 17.0)),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top:20.0, left: 20.0),
            color: Colors.white,
            child: TapCallback(
              onPressed: () {Navigator.of(context).pushNamed('personalSet',arguments: '我的地址');},
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child:  Text('我的地址',style: TextStyle(color: Colors.black,fontSize: 17.0)),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top:20.0, left: 20.0),
            color: Colors.white,
            child: TapCallback(
              onPressed: () {},
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child:  Text('更多',style: TextStyle(color: Colors.black,fontSize: 17.0)),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}