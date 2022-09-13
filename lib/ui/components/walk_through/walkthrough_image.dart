import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pro1/ui/components/fade_down_transition.dart';

class WalkthroughImage extends StatelessWidget {
  const WalkthroughImage({
    Key key,
    this.text,
    @required this.assetImage,
    this.imageSize = 230,
    this.showText = true,
    this.allowPinchHole = false,
    this.imageType = ImageType.lottie,
    this.textLocation = TextLocation.Bottom,
    this.alignment = Alignment.center,
  }) : super(key: key);
  final String text;
  final String assetImage;
  final TextLocation textLocation;
  final Alignment alignment;
  final bool allowPinchHole;
  final bool showText;
  final double imageSize;
  final ImageType imageType;

  @override
  Widget build(BuildContext context) {
    return FadeDownTransition(
      duration: Duration(milliseconds: 1500),
      child: IgnorePointer(
        child: Container(
          alignment: alignment,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (textLocation == TextLocation.Top && showText)
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: HintText(text: text),
                ),
              if (imageType == ImageType.lottie)
                Lottie.asset(assetImage, fit: BoxFit.fitWidth, width: imageSize)
              else if (imageType == ImageType.image)
                Image.asset(assetImage, fit: BoxFit.fitWidth, width: imageSize),
              if (textLocation == TextLocation.Bottom && showText)
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: HintText(text: text),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class HintText extends StatelessWidget {
  const HintText({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 82, minWidth: 50),
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }
}

enum TextLocation { Top, Bottom }
enum ImageType { lottie, image }
