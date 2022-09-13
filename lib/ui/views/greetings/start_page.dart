import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pro1/ui/components/FadeAnimation.dart';
import 'package:stacked_themes/stacked_themes.dart';

class StartPage extends StatefulWidget {
  final String mainHeadingText;
  final String contentText;

  const StartPage({Key key, this.mainHeadingText, this.contentText})
      : super(key: key);
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  AnimationController _colorController;
  AnimationController _scaleController;

  @override
  void initState() {
    _colorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )
      ..addListener(() async {
        if (_colorController.isCompleted) {
          await Future.delayed(Duration(milliseconds: 300));
          _colorController.reverse();
        } else if (_colorController.isDismissed) {
          _colorController.forward();
        }
      })
      ..forward();

    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    )
      ..addListener(() async {
        setState(() {});
      })
      ..drive(CurveTween(curve: Curves.bounceInOut))
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
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: new BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                stops: [0.0, 0.4, 0.6],
                end: Alignment.bottomCenter,
                colors: [Colors.lightBlue, Colors.white, Colors.white])),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 300,
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: -50,
                          left: 20,
                          child: Transform.scale(
                            scale: _scaleController.value,
                            child: Lottie.asset("assets/lottie/hello3.json",
                                fit: BoxFit.fitWidth, width: 350),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FadeAnimation(
                      1.3,
                      Text(
                        widget.contentText,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.inter(
                            color: Colors.black54, height: 1.4, fontSize: 20),
                      )),
                  SizedBox(
                    height: 260,
                  ),
                ],
              ),
            ),
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
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
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
