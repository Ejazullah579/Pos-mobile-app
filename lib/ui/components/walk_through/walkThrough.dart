import 'package:flutter/material.dart';
import 'package:pro1/ui/components/FadeAnimation.dart';
import 'package:pro1/ui/components/walk_through/walkthrough_image.dart';
import 'package:pro1/ui/components/walk_through/info_box.dart';
import 'package:pro1/ui/components/walk_through/overlay.dart' as overlay;

class WalkThrough extends StatefulWidget {
  WalkThrough(
      {Key key,
      @required this.child,
      @required this.data,
      @required this.startWalkthrough,
      @required this.onComplete,
      this.onChange})
      : super(key: key);
  final bool startWalkthrough;
  final Widget child;
  final List<WalkThroughData> data;
  final Function onComplete;
  final Function(int index) onChange;

  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  int selectedWidget = 0;
  bool endWalkthrough = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          widget.child,
          if (widget.startWalkthrough && !endWalkthrough)
            GestureDetector(
              onTap: () async {
                if (selectedWidget < widget.data.length - 1) {
                  selectedWidget += 1;
                  if (widget.onChange != null) widget.onChange(selectedWidget);
                } else {
                  endWalkthrough = true;
                  await widget.onComplete();
                }
                setState(() {});
              },
              child: FadeAnimation(
                1,
                overlay.Overlay(
                  data: widget.data[selectedWidget],
                ),
              ),
            ),
          if (widget.startWalkthrough && !endWalkthrough)
            InfoBox(
              data: widget.data[selectedWidget],
            ),
        ],
      ),
    );
  }
}

class WalkThroughData {
  final GlobalKey key;
  final String hintText;
  final HintTextLocation location;
  final InfoType infoType;
  final Widget widget;
  final WalkthroughImage image;
  final bool showAnimation;
  final bool shouldCutChildHole;
  final bool shouldUseBothHintTextAndWidget;
  final Rect widgetPosition;
  final Alignment widgetAlignment;
  final BorderRadius pinchHoleRadius;
  WalkThroughData({
    this.key,
    this.location,
    this.image,
    this.hintText,
    this.pinchHoleRadius,
    this.widgetPosition,
    this.shouldUseBothHintTextAndWidget = false,
    this.widgetAlignment = Alignment.center,
    this.infoType = InfoType.hintText,
    this.shouldCutChildHole = true,
    this.showAnimation = true,
    this.widget,
  });
}

enum HintTextLocation { Top, Bottom, Left, Right }
enum InfoType { Image, widget, hintText }
