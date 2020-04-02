import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:yim/chat/personal_chat.dart';
import 'package:yim/personal/personal_info.dart';
import 'package:yim/personal/personal.dart';

import 'apps/apps.dart';
import 'common/global.dart';
import 'login/login.dart';
import 'messages/messages.dart';
import 'model/user.dart';
import 'personal/personal_set.dart';
import 'states/profile_change_notifier.dart';
import 'widget/contacts_drawer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    User fromUser = User();
    fromUser.id = 111;
    fromUser.login = 'user1';
    fromUser.avatar_url = 'http://www.17qq.com/img_qqtouxiang/84602511.jpeg';
    User toUser = User();
    toUser.id = 111;
    toUser.login = 'user2';
    toUser.avatar_url = 'http://pic2.zhimg.com/50/v2-0e944ad4ae60f225ac166a074ed8b985_hd.jpg';

    return MultiProvider(
      providers: <SingleChildWidget> [
        ChangeNotifierProvider.value(value: UserModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yim',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: MyHomePage(title: 'Yim'),
        routes: <String, WidgetBuilder> {
          "login": (context) => LoginRoute(),
          "personalChat": (context) => PersonalChat(fromUser: fromUser,toUser: toUser),
          "personalInfo": (context) => PersonalInfo(),
          "personalSet": (context) => PersonalSet(title: ModalRoute.of(context).settings.arguments),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;

  // 会话页面
  Messages _messages;
  // 小程序页面
  Apps apps;
  // 个人页面
  Personal _personal;

  //根据当前索引返回不同的页面
  _currentPage() {
    switch (_selectedIndex) {
      case 0:
        if(_messages == null) {
          _messages = Messages();
        }
        return _messages;
      case 1:
        if(apps == null) {
          apps = Apps();
        }
        return apps;
      case 2:
        if(_personal == null) {
          _personal = Personal();
        }
        return _personal;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.message), title: Text('Messages')),
          BottomNavigationBarItem(icon: Icon(Icons.apps), title: Text('Apps')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Person'))
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.grey,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.deepOrangeAccent,
        onTap: _onItemTapped,
      ),
      drawer: ContactsDrawer(),
    );
  }

  Widget _buildBody() {
    UserModel userModel = Provider.of<UserModel>(context);
    if(!userModel.isLogin) {
      // 用户未登录，显示登录按钮
      return Center(
        child: RaisedButton(
          child: Text("登录"),
          onPressed: () => Navigator.of(context).pushNamed("login"),
        ),
      );
    } else {
      return _currentPage();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
