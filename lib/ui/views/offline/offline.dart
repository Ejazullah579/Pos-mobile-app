import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class OfflineView extends StatefulWidget {
  OfflineView({Key key}) : super(key: key);

  @override
  _OfflineViewState createState() => _OfflineViewState();
}

class _OfflineViewState extends State<OfflineView>
    with TickerProviderStateMixin {
  var transitionController;
  var rotationController;
  var animation;
  var rotateAnimation;
  AnimationController dotTimer;

  @override
  void initState() {
    super.initState();
    transitionController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 7),
        lowerBound: 0,
        upperBound: 1)
      ..addListener(() {
        if (transitionController.isCompleted)
          transitionController.reverse();
        else if (transitionController.isDismissed)
          transitionController.forward();
        setState(() {});
      })
      ..forward();

    dotTimer = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2200),
        lowerBound: 0,
        upperBound: 4.5)
      ..addListener(() {
        if (dotTimer.value / 1 == 0) setState(() {});
      })
      ..repeat();

    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: transitionController,
      curve: Interval(
        0,
        1,
      ),
    ));

    rotationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 30),
        lowerBound: 0,
        upperBound: 1)
      ..addListener(() {
        setState(() {});
      })
      ..repeat();

    rotateAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: rotationController,
        curve: Interval(
          0,
          1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    transitionController.dispose();
    rotationController.dispose();
    dotTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeManger = getThemeManager(context).isDarkMode;
    final maxheight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        await BottomSheetService()
            .showBottomSheet(
                title: "Exit?",
                description: "Are you sure you want to exit",
                confirmButtonTitle: "Exit",
                cancelButtonTitle: "Cancel")
            .then((value) {
          if (value != null) {
            if (value.confirmed) SystemNavigator.pop();
          }
        });
      },
      child: Container(
        color: themeManger ? Colors.black : Colors.white,
        child: Stack(
          children: [
            DecoratedCircle(
              top: -70,
              left: -70,
              radius: 180,
              color: Colors.red,
            ),
            DecoratedCircle(
              bottom: 40,
              right: -40,
              radius: 140,
              shape: BoxShape.rectangle,
              color: Colors.purple,
              borderRadius: BorderRadius.circular(30),
            ),
            DecoratedCircle(
              bottom: maxheight / 2,
              left: -80,
              radius: 140,
              shape: BoxShape.rectangle,
              color: Colors.purple,
              borderRadius: BorderRadius.circular(30),
            ),
            DecoratedCircle(
              bottom: 40,
              left: -20,
              radius: 150,
              color: Colors.blue,
            ),
            DecoratedCircle(
              top: 20,
              right: 20,
              radius: 120,
              color: Colors.blue,
            ),
            DecoratedCircle(
              top: maxheight / 3.5,
              right: 20,
              radius: 120,
              color: Colors.orangeAccent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(30),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: animation.value * -100,
                        child: AnimatedBuilder(
                          animation: rotationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: 2 * 3.14 * rotateAnimation.value,
                              child: child,
                            );
                          },
                          child: PhysicalModel(
                            color: Colors.transparent,
                            shadowColor: themeManger
                                ? Colors.white
                                    .withOpacity(transitionController.value)
                                : Colors.black54,
                            elevation: 20,
                            shape: BoxShape.circle,
                            child: Image.asset(
                              "assets/images/no_connection.png",
                              height: 200,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  decoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Text(
                        "No Internet Connection",
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                            color: !themeManger ? Colors.black : Colors.white),
                      ),
                      Container(
                        height: 20,
                        width: maxWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Retrying ",
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                  color: !themeManger
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            Container(
                              width: 50,
                              height: 20,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: dotTimer.value.round(),
                                itemBuilder: (context, index) => Container(
                                  height: 2,
                                  margin: EdgeInsets.only(right: 5),
                                  width: 3,
                                  decoration: BoxDecoration(
                                      color: themeManger
                                          ? Colors.white
                                          : Colors.black,
                                      shape: BoxShape.circle),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Please connect to internet",
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                      color: !themeManger ? Colors.black : Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DecoratedCircle extends StatelessWidget {
  const DecoratedCircle({
    Key key,
    this.top,
    this.bottom,
    this.left,
    this.radius,
    this.right,
    this.color,
    this.shape,
    this.borderRadius,
  }) : super(key: key);
  final double top;
  final double bottom;
  final double left;
  final double radius;
  final double right;
  final Color color;
  final BoxShape shape;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
            color: color,
            shape: shape != null ? shape : BoxShape.circle,
            borderRadius: borderRadius != null ? borderRadius : null),
      ),
    );
  }
}
