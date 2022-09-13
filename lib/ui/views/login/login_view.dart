import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/app/router.gr.dart' as router;
import 'package:pro1/ui/components/MainButtons.dart';
import 'package:pro1/ui/components/TextField1.dart';
import 'package:pro1/ui/views/sign_up/sign_up_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'forget_password_view.dart';
import 'login_viewmodel.dart';

// ignore: must_be_immutable
class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  FocusScopeNode currentFocus;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scalfoldKey = GlobalKey<ScaffoldState>();
  final FocusNode focusNode1 = FocusNode();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(seconds: 6),
        vsync: this,
        lowerBound: 0,
        upperBound: 25)
      ..addListener(() {
        if (_controller.isCompleted)
          _controller.reverse();
        else if (_controller.isDismissed) _controller.forward();
        setState(() {});
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxheight = MediaQuery.of(context).size.height;
    currentFocus = FocusScope.of(context);
    final themeManager = getThemeManager(context);
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        builder: (context, model, child) => GestureDetector(
          onTap: () => {
            if (!currentFocus.hasPrimaryFocus) {currentFocus.unfocus()}
          },
          child: Scaffold(
            key: scalfoldKey,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Container(
                  height: maxheight,
                  decoration: new BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          stops: [0.0, 0.4, 0.6],
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.lightBlue,
                            !themeManager.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            themeManager.isDarkMode
                                ? Colors.black
                                : Colors.white
                          ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
////////////////////////////////////////////////////
////////////////////// Image Container ////////////
//////////////////////////////////////////////////
                      Container(
                        height: maxheight * 0.30,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              bottom: _controller.value,
                              child: Container(
                                child: new Image.asset(
                                  'assets/images/fire.png',
                                  height: maxheight * 0.30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text("Login",
                            style: GoogleFonts.patuaOne(
                              fontSize: 35,
                              letterSpacing: 3.5,
                              color: !themeManager.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                            )),
                      ),
//////////////////////////////////////////////////
////////////////////////////// Form Container////
////////////////////////////////////////////////
                      Container(
                        padding: EdgeInsets.only(
                            bottom: (maxheight * 3 / 100), left: 25, right: 25),
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        child: Column(
                          children: [
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       top: 10, bottom: 4),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: [
                                  //       // Text(model.errormessage,
                                  //       //     style: GoogleFonts.patuaOne(
                                  //       //         fontSize: 15,
                                  //       //         color: Colors.red[400],
                                  //       //         decoration:
                                  //       //             TextDecoration.none)),
                                  //     ],
                                  //   ),
                                  // ),
                                  TextField1(
                                    hinttext: "User Name",
                                    onSave: "username",
                                    textFieldIcon: Icon(Icons.person),
                                    autoValidate: false,
                                    focusNode: FocusNode(),
                                    textInputAction: TextInputAction.next,
                                    focusnode: () {
                                      currentFocus.requestFocus(focusNode1);
                                    },
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: "Email Required"),
                                      PatternValidator(
                                          r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
                                          errorText:
                                              "Enter a valid Email address")
                                    ]),
                                  ),
                                  TextField1(
                                    hinttext: "Password",
                                    focusNode: focusNode1,
                                    isPasswordField: true,
                                    textFieldIcon: Icon(Icons.lock),
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: "Password Required"),
                                      MinLengthValidator(8,
                                          errorText:
                                              "Minimum Length should be 8")
                                    ]),
                                    onSave: "userpass",
                                    autoValidate: false,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      NavigationService()
                                          .navigateWithTransition(
                                        ForgetPasswordView(),
                                        duration: Duration(milliseconds: 700),
                                        transition:
                                            NavigationTransition.LeftToRight,
                                      );
                                    },
                                    child: Text("Forgot your Password?",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: themeManager.isDarkMode
                                                ? Colors.white70
                                                : Colors.black54,
                                            decoration: TextDecoration.none)),
                                  ),
                                ),
                              ],
                            ),
////////////////////////////////////////////////////////////
/////////////////////////// Login/ Sign up button /////////
//////////////////////////////////////////////////////////
                            model.isBusy
                                ? Container(
                                    height: 47,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 10),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Center(
                                      child: FittedBox(
                                        child: CircularProgressIndicator(
                                          backgroundColor:
                                              themeManager.isDarkMode
                                                  ? Colors.black
                                                  : Colors.white,
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  themeManager.isDarkMode
                                                      ? Colors.white
                                                      : Colors.blue),
                                          strokeWidth: 5,
                                        ),
                                      ),
                                    ),
                                  )
                                : MainButtons(
                                    buttontext: "Login",
                                    borderColor: Colors.cyan,
                                    textColor: Colors.cyan,
                                    // btnIcon: Icon(
                                    //   Icons.login,
                                    //   color: Colors.cyan,
                                    // ),
                                    onpress: () {
                                      if (!formKey.currentState.validate()) {
                                        return;
                                      } else {
                                        formKey.currentState.save();
                                        model.login();
                                      }
                                    },
                                  ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: themeManager.isDarkMode
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                ),
                                Text(
                                  " or ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: themeManager.isDarkMode
                                          ? Colors.white70
                                          : Colors.black54,
                                      decoration: TextDecoration.none),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: themeManager.isDarkMode
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            MainButtons(
                              buttontext: "Sign up",
                              borderColor: themeManager.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              textColor: themeManager.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              // btnIcon: Icon(
                              //   Icons.add,
                              //   color: themeManager.isDarkMode
                              //       ? Colors.white60
                              //       : Colors.black38,
                              // ),
                              onpress: () => {
                                NavigationService().navigateWithTransition(
                                  SignupView(),
                                  duration: Duration(milliseconds: 700),
                                  transition: NavigationTransition.RightToLeft,
                                )
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
