import 'package:flutter/material.dart';
import 'package:yim/model/follows.dart';
import 'package:yim/model/friends.dart';
import 'package:yim/model/groups.dart';
import 'package:yim/model/user.dart';

class ContactsItem extends StatelessWidget {

  Friends friend;
  Groups groups;
  Follows follows;

  ContactsItem({Friends friend, Groups groups, Follows follows}) {
    this.friend = friend;
    this.groups = groups;
    this.follows = follows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: .5, color: Color(0xFFd9d9d9))),
      ),
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed( "personalChat");
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              friend != null ? friend.userAvatar : groups != null ? groups.groupAvatar : follows.userAvatar,
              width: 36.0,
              height: 36.0,
              scale: 0.9,
            ),
            Container(
              margin: const EdgeInsets.only(left: 12.0),
              child: Text(
                friend != null ? friend.userName : groups != null ? groups.groupName : follows.userName,
                style: TextStyle(fontSize: 18.0, color: Color(0xFF353535)),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

}