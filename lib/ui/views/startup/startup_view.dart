import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'startup_viewmodel.dart';

class StartupView extends StatelessWidget {
  StartupView({Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      viewModelBuilder: () => StartupViewModel(),
      onModelReady: (model) => model.handleStartUpLogic(context),
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scafoldKey,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SH",
                        style: GoogleFonts.inter(
                            fontSize: 47,
                            fontWeight: FontWeight.w600,
                            color: getThemeManager(context).isDarkMode
                                ? Colors.white
                                : Colors.black),
                      ),
                      model.isBusy
                          ? Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: CircularProgressIndicator(
                                  strokeWidth: 6,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.orange),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Image.asset(
                                "assets/images/start.gif",
                                height: 45,
                                width: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                      Text(
                        "PIFY",
                        style: GoogleFonts.inter(
                            fontSize: 47,
                            fontWeight: FontWeight.w600,
                            color: getThemeManager(context).isDarkMode
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    model.workingInfo,
                    style: TextStyle(
                        color: getThemeManager(context).isDarkMode
                            ? Colors.white54
                            : Colors.black54,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            model.currentUser != null
                ? WelcomeUserText(
                    currentUser: model.currentUser,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class WelcomeUserText extends StatefulWidget {
  const WelcomeUserText({
    Key key,
    this.currentUser,
  }) : super(key: key);
  final currentUser;
  @override
  _WelcomeUserTextState createState() => _WelcomeUserTextState();
}

class _WelcomeUserTextState extends State<WelcomeUserText>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600))
          ..forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => ScaleTransition(
        scale: _controller,
        child: child,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Welcome back ",
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      color: getThemeManager(context).isDarkMode
                          ? Colors.white54
                          : Colors.black54)),
              TextSpan(
                  text: widget.currentUser.firstName,
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600))
            ]),
          ),
        ),
      ),
    );
  }
}
