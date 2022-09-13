import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/app/router.gr.dart';
import 'package:pro1/services/shared_prefrences_service.dart';
import 'package:pro1/ui/components/FadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

class EndPage extends StatefulWidget {
  final String mainHeadingText;
  final String contentText;

  const EndPage({Key key, this.mainHeadingText, this.contentText})
      : super(key: key);
  @override
  _EndPageState createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> with TickerProviderStateMixin {
  AnimationController _scaleController;
  AnimationController _scale2Controller;
  AnimationController _widthController;
  AnimationController _positionController;

  Animation<double> _scaleAnimation;
  Animation<double> _scale2Animation;
  Animation<double> _widthAnimation;
  // ignore: unused_field
  Animation<double> _positionAnimation;

  bool hideIcon = false;

  @override
  void initState() {
    super.initState();

    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _widthController.forward();
            }
          });

    _widthController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _widthAnimation =
        Tween<double>(begin: 80.0, end: 300.0).animate(_widthController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              // _positionController.forward();
            }
          });

    _positionController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 215.0,
        duration: Duration(milliseconds: 500))
      ..addListener(() {
        if (_positionController.value > _positionController.value / 2) {
          _positionController.forward();
        } else {
          _positionController.reverse();
        }
      });

    _positionAnimation =
        Tween<double>(begin: 0.0, end: 215.0).animate(_positionController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                hideIcon = true;
              });
              _scale2Controller.forward();
            }
          });

    _scale2Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _scale2Animation =
        Tween<double>(begin: 1.0, end: 32.0).animate(_scale2Controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              SharedPrefrencesService().setIsFirstTime();
              NavigationService().replaceWith(Routes.loginView);
            }
          });
  }

  void dispose() {
    _scaleController.dispose();
    _scale2Controller.dispose();
    _widthController.dispose();
    _positionController.dispose();

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
                  FadeAnimation(
                      1,
                      Text(
                        widget.mainHeadingText,
                        style: GoogleFonts.poly(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.w600),
                      )),
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
                    height: 150,
                  ),
                  FadeAnimation(
                      1.6,
                      AnimatedBuilder(
                        animation: _scaleController,
                        builder: (context, child) => Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _widthController,
                                builder: (context, child) => Container(
                                  width: _widthAnimation.value,
                                  height: 80,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.blue.withOpacity(.4)),
                                  child: InkWell(
                                    onTap: () {
                                      _scaleController.forward();
                                    },
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Stack(children: <Widget>[
                                      AnimatedBuilder(
                                          animation: _positionController,
                                          builder: (context, child) =>
                                              Positioned(
                                                left: _positionController.value,
                                                child: AnimatedBuilder(
                                                  animation: _scale2Controller,
                                                  builder: (context, child) =>
                                                      Transform.scale(
                                                          scale:
                                                              _scale2Animation
                                                                  .value,
                                                          child:
                                                              GestureDetector(
                                                            onHorizontalDragUpdate:
                                                                (details) {
                                                              var value = details
                                                                  .primaryDelta;

                                                              if (value < 0 ||
                                                                  _positionController
                                                                          .value >
                                                                      value) {
                                                                if (_positionController
                                                                        .value >
                                                                    0) {
                                                                  setState(() {
                                                                    _positionController
                                                                            .value +=
                                                                        value;
                                                                  });
                                                                }
                                                              } else if (value >
                                                                      0 &&
                                                                  _positionController
                                                                          .value <
                                                                      value) {
                                                                setState(() {
                                                                  _positionController
                                                                          .value +=
                                                                      value;
                                                                });
                                                              }
                                                            },
                                                            child: Container(
                                                              width: 60,
                                                              height: 60,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white),
                                                              child: hideIcon ==
                                                                      false
                                                                  ? Icon(
                                                                      Icons
                                                                          .arrow_forward,
                                                                      color: Colors
                                                                          .blue,
                                                                    )
                                                                  : Container(),
                                                            ),
                                                          )),
                                                ),
                                              )),
                                    ]),
                                  ),
                                ),
                              ),
                            )),
                      )),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
