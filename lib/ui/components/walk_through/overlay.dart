import 'package:flutter/material.dart';
import 'package:pro1/ui/extensions/global_location.dart';
import 'package:pro1/ui/components/walk_through/walkThrough.dart';

class Overlay extends StatelessWidget {
  const Overlay({Key key, @required this.data}) : super(key: key);
  final WalkThroughData data;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.black87, BlendMode.srcOut),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: data.infoType == InfoType.widget
            ? Container()
            : data.infoType == InfoType.Image
                ? data.image.allowPinchHole
                    ? PinchHole(data: data)
                    : Container()
                : PinchHole(data: data),
      ),
    );
  }
}

class PinchHole extends StatelessWidget {
  const PinchHole({
    Key key,
    @required this.data,
  }) : super(key: key);

  final WalkThroughData data;

  @override
  Widget build(BuildContext context) {
    RenderObject box = data.key.currentContext.findRenderObject();

    return Stack(
      children: [
        Positioned(
          top: data.key.globalPaintBounds.top - 5,
          left: data.key.globalPaintBounds.left - 5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              height: box.paintBounds.size.height + 10,
              width: box.paintBounds.size.width + 10,
              decoration: BoxDecoration(
                color: Colors
                    .black, // Color does not matter but should not be transparent
                borderRadius: data.pinchHoleRadius != null
                    ? data.pinchHoleRadius
                    : BorderRadius.circular(100),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
