import 'package:flutter/material.dart';
import 'package:yim/model/follows.dart';
import 'package:yim/model/friends.dart';
import 'package:yim/model/groups.dart';
import 'package:yim/widget/contacts_item.dart';

class ContactsDrawer extends StatefulWidget {
  @override
  _ContactsDrawerState createState() => _ContactsDrawerState();
}

class _ContactsDrawerState extends State<ContactsDrawer>
    with SingleTickerProviderStateMixin {
  static const double dragThreshold = 50.0;
  static const List tabs = ["好友", "群聊", "关注"];

  TabController _tabController; //需要定义一个Controller
  ScrollController _scrollViewController = new ScrollController();
  ScrollController _listViewController = new ScrollController();


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {});
    _scrollViewController.addListener(() {});
    _listViewController.addListener(() {
      _scrollViewController.jumpTo(_listViewController.offset);
    });
  }

  @override
  Widget build(BuildContext context) {

    var downDx;
    ScrollPhysics _scrollable = AlwaysScrollableScrollPhysics();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Listener(
        onPointerDown: (e) {
          downDx = e.position.dx;
        },
        onPointerUp: (e) {
          if (_tabController.index == tabs.length - 1) {
            if (downDx - e.position.dx > dragThreshold) {
              Navigator.pop(context);
            }
          }
        },
        child: Scrollbar(
          child: CustomScrollView(
            controller: _scrollViewController,
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                expandedHeight: 232.0,
                // 使用透明Icon替换掉默认Icon
                leading: IconButton(
                  icon: Image.asset("images/ic_transparent.png"),
                  onPressed: () {},
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.close,size: 30.0,),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
                actionsIconTheme: IconThemeData(
                  color: Colors.white,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.loose,
                    children: <Widget>[
                      Image.asset(
                        "images/bg_contacts.jpg",
                        fit: BoxFit.cover,
                      ),
                      ClipOval(
                          child: Image.asset(
                            "images/ironman.jpg",
                            width: 80.0,
                          )),
                      Positioned(
                        bottom: 60.0,
                        child: Text('严鸿鑫',
                            style:
                            TextStyle(color: Colors.white, fontSize: 20.0)),
                      ),
                      Positioned(
                        bottom: 40.0,
                        child: Text('生命，那是自然会给人类去雕琢的宝石',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 15.0)),
                      ),
                    ],
                  ),
                ),
                bottom: TabBar(
                    labelColor: Colors.white,
                    controller: _tabController,
                    tabs: tabs.map((e) => Tab(text: e)).toList()),
              ),
              SliverFillRemaining(
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: TabBarView(
                    controller: _tabController,
                    children: tabs.map((e) {
                      return ListView.builder(
                        controller: _listViewController,
                        physics: _scrollable,
                        itemCount: e == "好友" ? friendsData.length : e == "群聊" ? groupsData.length : followsData.length,
                        itemBuilder: (BuildContext context, int index) {
                          if(e == "好友") {
                            return ContactsItem(friend: friendsData[index]);
                          } else if(e == "群聊"){
                            return ContactsItem(groups: groupsData[index]);
                          } else {
                            return ContactsItem(follows: followsData[index]);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}