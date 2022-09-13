import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pro1/ui/components/FadeAnimation.dart';

class Pages extends StatefulWidget {
  const Pages({
    Key key,
    this.mainHeadingText,
    this.paragraphText,
    this.image,
  }) : super(key: key);
  final String mainHeadingText;
  final String paragraphText;
  final String image;

  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> with TickerProviderStateMixin {
  AnimationController _scaleController;
  AnimationController _colorController;

  @override
  void initState() {
    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..forward();
    super.initState();

    _colorController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500))
          ..addListener(() async {
            if (_colorController.isCompleted) {
              await Future.delayed(Duration(milliseconds: 300));

              _colorController.reverse();
            } else if (_colorController.isDismissed) {
              _colorController.forward();
            }
          })
          ..forward();

    super.initState();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Container(
        width: double.infinity,
        decoration: new BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                stops: [0.0, 0.4, 0.6],
                end: Alignment.bottomCenter,
                colors: [Colors.lightBlue, Colors.white, Colors.white])),
        child: Stack(
          children: [
            Positioned(
                top: 80,
                child: Container(
                  height: maxHeight * 0.7,
                  width: maxWidth,
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _scaleController,
                        builder: (context, child) => Transform.scale(
                          alignment: Alignment.center,
                          scale: _scaleController.value,
                          child: Lottie.asset(widget.image,
                              fit: BoxFit.fitWidth, width: 230),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FadeAnimation(
                                1,
                                Text(
                                  widget.mainHeadingText,
                                  style: GoogleFonts.poly(
                                      color: Colors.black,
                                      fontSize: 40,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w600),
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            FadeAnimation(
                                1.3,
                                Text(
                                  widget.paragraphText,
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.inter(
                                      color: Colors.black54,
                                      height: 1.4,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.none,
                                      fontSize: 20),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: FadeAnimation(
                1,
                AnimatedBuilder(
                  animation: _colorController,
                  builder: (context, child) => Container(
                    width: 200,
                    height: 60,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        "Swipe Left",
                        style: GoogleFonts.inter(
                            color: Colors.white
                                .withOpacity(_colorController.value),
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
