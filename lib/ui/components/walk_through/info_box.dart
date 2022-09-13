import 'package:flutter/material.dart';
import 'package:pro1/ui/components/fade_down_transition.dart';
import 'package:pro1/ui/components/walk_through/walkThrough.dart';
import 'package:pro1/ui/extensions/global_location.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({Key key, @required this.data}) : super(key: key);
  final WalkThroughData data;

  @override
  Widget build(BuildContext context) {
    return data.infoType == InfoType.Image
        ? data.image
        : data.infoType == InfoType.widget
            ? IgnorePointer(
                child: FadeDownTransition(
                  duration: Duration(milliseconds: 1500),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: data.widgetAlignment,
                    child: data.widget,
                  ),
                ),
              )
            : HintText(data: data);
  }
}

class HintText extends StatefulWidget {
  const HintText({
    Key key,
    @required this.data,
  }) : super(key: key);

  final WalkThroughData data;

  @override
  _HintTextState createState() => _HintTextState();
}

class _HintTextState extends State<HintText>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 3000),
        lowerBound: -5,
        upperBound: 5)
      ..addListener(() {
        if (_controller.isCompleted)
          _controller.reverse();
        else if (_controller.isDismissed) _controller.forward();
        setState(() {});
      })
      ..drive(CurveTween(curve: Curves.decelerate))
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RenderObject box = widget.data.key.currentContext.findRenderObject();
    return Positioned(
        top: (widget.data.location == HintTextLocation.Left ||
                widget.data.location == HintTextLocation.Right
            ? widget.data.key.globalPaintBounds.top + 5 + (_controller.value)
            : (widget.data.location == HintTextLocation.Top
                ? widget.data.key.globalPaintBounds.top -
                    (60) +
                    (_controller.value)
                : widget.data.location == HintTextLocation.Bottom
                    ? widget.data.key.globalPaintBounds.bottom +
                        widget.data.key.globalPaintBounds.top / 2 +
                        (_controller.value)
                    : null)),
        left: widget.data.location == HintTextLocation.Left ? 20 : null,
        right: widget.data.location == HintTextLocation.Right ? 20 : null,
        child: IgnorePointer(
          child: FadeDownTransition(
            duration: Duration(milliseconds: 1500),
            child: Container(
              width: widget.data.location != HintTextLocation.Left &&
                      widget.data.location != HintTextLocation.Right
                  ? MediaQuery.of(context).size.width
                  : null,
              color: Colors.transparent,
              alignment: widget.data.location != HintTextLocation.Left ||
                      widget.data.location != HintTextLocation.Right
                  ? Alignment.center
                  : null,
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 30,
                    minWidth: 50),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (widget.data.location == HintTextLocation.Right)
                    Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black54,
                        )),
                  Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 82,
                          minWidth: 50),
                      child: Text(widget.data.hintText)),
                  if (widget.data.location != HintTextLocation.Right)
                    Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          widget.data.location == HintTextLocation.Left
                              ? Icons.arrow_forward
                              : widget.data.location == HintTextLocation.Top
                                  ? Icons.arrow_downward
                                  : widget.data.location ==
                                          HintTextLocation.Bottom
                                      ? Icons.arrow_upward
                                      : Icons.arrow_back,
                          color: Colors.black54,
                        ))
                ]),
              ),
            ),
          ),
        ));
  }
}
