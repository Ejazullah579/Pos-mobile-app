import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FadeDownTransition extends StatefulWidget {
  FadeDownTransition({
    Key key,
    @required this.duration,
    @required this.child,
    this.startAnimation = true,
  }) : super(key: key);

  final Duration duration;
  final Widget child;
  bool startAnimation;

  @override
  _FadeDownTransitionState createState() => _FadeDownTransitionState();
}

class _FadeDownTransitionState extends State<FadeDownTransition>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool previousValue = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
        // if (_controller.isCompleted && previousValue != widget.startAnimation) {
        //   _controller.value = 0;
        //   _controller.forward();
        //   previousValue = widget.startAnimation;
        // }
        setState(() {});
      });
    if (widget.startAnimation) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("here");
    return Transform.translate(
      offset: Offset(0, (_controller.value * 20) - 20),
      child: Opacity(opacity: _controller.value, child: widget.child),
    );
  }
}
