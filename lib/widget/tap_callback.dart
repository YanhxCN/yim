import 'package:flutter/material.dart';

class TapCallback extends StatefulWidget {

  final Widget child;
  final VoidCallback onPressed;
  final bool isFeed; // 是否激活点击事件
  final Color background;


  TapCallback({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.isFeed: true,
    this.background: const Color(0xffd8d8d8),
  }) : super(key:key);

  @override
  _TapCallbackState createState() => _TapCallbackState();
}

class _TapCallbackState extends State<TapCallback> {

  Color _color = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector (
      child: Container (
        color: _color,
        child: widget.child,
      ),
      onTap: widget.onPressed,
      onPanDown: (d) {
        if(widget.isFeed == false) return;
        setState(() {
          _color = widget.background;
        });
      },
      onPanCancel: () {
        setState(() {
          _color = Colors.transparent;
        });
      },
    );
  }

}