import 'package:flutter/material.dart';

class PersonalSet extends StatefulWidget {

  final String title;

  const PersonalSet({Key key, this.title}) : super(key: key);

  @override
  _PersonalSetState createState() => _PersonalSetState();
}

class _PersonalSetState extends State<PersonalSet> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }

}