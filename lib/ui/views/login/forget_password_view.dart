import 'dart:ui';

import "package:flutter/material.dart";
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/ui/components/MainButtons.dart';
import 'package:pro1/ui/components/TextField2.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'login_viewmodel.dart';

class ForgetPasswordView extends StatefulWidget {
  ForgetPasswordView({Key key}) : super(key: key);

  @override
  _ForgetPasswordViewState createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  FocusScopeNode currentFocus;
  bool isVisible = true;
  GlobalKey<ScaffoldState> scalfoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final maxheight = MediaQuery.of(context).size.height;
    // final maxwidth = MediaQuery.of(context).size.height;
    final themeManager = getThemeManager(context);
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => {
          currentFocus = FocusScope.of(context),
          if (!currentFocus.hasPrimaryFocus) {currentFocus.unfocus()}
        },
        child: Scaffold(
          key: scalfoldKey,
          body: SingleChildScrollView(
            child: Container(
                height: maxheight,
                decoration: new BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        stops: [0.0, 0.5, 0.7],
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.lightBlue,
                          !themeManager.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          themeManager.isDarkMode ? Colors.black : Colors.white
                        ])),
                child: Stack(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: isVisible ? 1 : 0,
                          child: Container(
                            child: new Image.asset(
                              'assets/images/forget_password2.png',
                              height: maxheight * 0.40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text("Forget Password",
                              style: GoogleFonts.inter(
                                fontSize: 35,
                                fontWeight: FontWeight.w600,
                                color: themeManager.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              bottom: (maxheight * 3 / 100),
                              left: 25,
                              right: 25),
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50))),
                          child: Column(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 20),
                              child: Text(
                                "Please provide an email that you submitted during signup to reset your password",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: getThemeManager(context).isDarkMode
                                        ? Colors.white54
                                        : Colors.black54),
                              ),
                            ),
                            Form(
                              key: formkey,
                              child: TextField2(
                                hinttext: "Enter Email Address",
                                textFieldIcon: Icon(Icons.email),
                                autoValidate: true,
                                con: _controller,
                                // onChange: (value) {
                                //   // print(value);
                                //   _controller.text = value;
                                // },
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Email Required"),
                                  PatternValidator(
                                      r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
                                      errorText: "Enter a valid Email address")
                                ]),
                              ),
                            ),
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
                                    buttontext: "Verify",
                                    borderColor: Colors.cyan,
                                    textColor: Colors.cyan,
                                    // btnIcon: Icon(
                                    //   Icons.verified_user,
                                    //   color: Colors.cyan,
                                    // ),
                                    onpress: () {
                                      if (!formkey.currentState.validate()) {
                                      } else
                                        model.resetPassword(_controller.text);
                                    },
                                  )
                          ]),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

// class ForgetPassword extends StatelessWidget {
//   const ForgetPassword({
//     Key key,
//     this.model,
//     this.formkey,
//     this.controller, this.onPress,
//   }) : super(key: key);
//   final GlobalKey<FormState> formkey;
//   final TextEditingController controller;
//   final Function onPress;
//   final model;
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

// class NewPassword extends StatelessWidget {
//   NewPassword({
//     Key key,
//     this.model,
//   }) : super(key: key);

//   final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
//   final GlobalKey<ScaffoldState> scalfoldKey = new GlobalKey<ScaffoldState>();
//   final model;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Form(
//           key: formKey,
//           child: Column(
//             children: [
//               TextField1(
//                 hinttext: "Enter New Password",
//                 onSave: "username",
//                 textFieldIcon: Icon(Icons.security_rounded),
//                 autoValidate: false,
//               ),
//               TextField1(
//                 hinttext: "Re-enter Password",
//                 textFieldIcon: Icon(Icons.wifi_protected_setup),
//                 onSave: "userpass",
//                 autoValidate: false,
//               ),
//             ],
//           ),
//         ),
//         model.isBusy
//             ? Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 child: CircularProgressIndicator(
//                   backgroundColor: Colors.blue[100],
//                   strokeWidth: 5,
//                 ),
//               )
//             : MainButtons(
//                 buttontext: "Verify",
//                 borderColor: Colors.cyan,
//                 textColor: Colors.cyan,
//                 btnIcon: Icon(
//                   Icons.verified_user,
//                   color: Colors.cyan,
//                 ),
//                 onpress: () {
//                   // formKey.currentState.save();
//                   // model.getUser();
//                 },
//               ),
//       ],
//     );
//   }
// }
