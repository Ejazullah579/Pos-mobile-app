import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/ui/components/MainButtons.dart';
import 'package:pro1/ui/components/hinttext.dart';
import 'package:pro1/ui/components/section_heading.dart';
import 'package:pro1/ui/views/sign_up/pages/page1.dart';
import 'package:pro1/ui/views/sign_up/pages/page2.dart';
import 'package:pro1/ui/views/sign_up/pages/page3.dart';
import 'package:pro1/ui/views/sign_up/sign_up_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

class SignupView extends StatefulWidget {
  SignupView({Key key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> scalfoldKey = GlobalKey<ScaffoldState>();
  double pageSize = 300;
  int currentPage = 0;
  double opacityValue = 0;
  bool showBackButton = false;
  final _controller = ScrollController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  final FocusNode focusNode6 = FocusNode();
  final FocusNode focusNode7 = FocusNode();
  final FocusNode focusNode8 = FocusNode();
  final FocusNode focusNode9 = FocusNode();

  ///////////// Set State Shortcuts //////////////////////////////
  /// For seting page heigth of step if errors pops ////
  setPageHeight(double value) {
    setState(() {
      pageSize = value;
    });
  }

////////// For setting Opacity of color in sign up sliver on scroll ///
  setOpacityValue(val) {
    setState(() {
      opacityValue = val;
    });
  }

///////// For Showing/Removing Back Button in signup sliver///////
  setShowBackButton(bool val) {
    setState(() {
      showBackButton = val;
    });
  }

///////// For Setting Step in Stepper if pressed Continue /////
  setCUrrentPage(value) {
    setState(() {
      currentPage += value;
    });
  }

  ////////////////////////////////////////////////////
  ///
  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      // if (_controller.offset > 0 && _controller.offset < 300) {
      //   if (_controller.offset <= 215) {
      //     setOpacityValue(0.0);
      //   } else if (_controller.offset > 215) {
      //     setOpacityValue(1.0);
      //   }
      // }
      // if (_controller.offset >= 280) {
      //   setShowBackButton(true);
      // } else {
      //   setShowBackButton(false);
      // }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    final themeManager = getThemeManager(context);
    final maxheight = MediaQuery.of(context).size.height;
    final maxwidth = MediaQuery.of(context).size.height;
    return ViewModelBuilder<SignupViewModel>.reactive(
      viewModelBuilder: () => SignupViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => {
          if (!currentFocus.hasPrimaryFocus) {currentFocus.unfocus()}
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          key: scalfoldKey,
          backgroundColor:
              themeManager.isDarkMode ? Colors.black : Colors.white,
          body: CustomScrollView(
            physics: ClampingScrollPhysics(),
            controller: _controller,
            slivers: [
////////////////////////////////////////////////////////
////// Image Sliver ///////////////////////////////////
//////////////////////////////////////////////////////
              SliverAppBar(
                expandedHeight: 300,
                pinned: false,
                backgroundColor:
                    themeManager.isDarkMode ? Colors.black : Colors.white,
                flexibleSpace: Hero(
                  tag: "login/signup",
                  child: Container(
                    height: maxheight * 0.4,
                    width: maxwidth,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            stops: [0.0, 0.8],
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.lightBlue,
                              !themeManager.isDarkMode
                                  ? Colors.white
                                  : Colors.black
                            ])),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 20),
                      child: new Image.asset('assets/images/signup.png',
                          height: maxheight * 0.23, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
///////////////////////////////////////////////////
//////// Sign Up text SLiver /////////////////////
/////////////////////////////////////////////////
              SliverAppBar(
                  expandedHeight: maxheight * 0.06,
                  elevation: 50,
                  pinned: false,
                  floating: true,
                  backgroundColor: Colors.transparent,
                  leading: showBackButton ? null : Container(),
                  flexibleSpace: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text("Signup",
                          style: GoogleFonts.patuaOne(
                            fontSize: 35,
                            letterSpacing: 3.5,
                            color: themeManager.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          )),
                    ),
                  )),
//////////////////////////////////////////////////////////////
////// Info text Sliver and Form ////////////////////////////
////////////////////////////////////////////////////////////

              SliverPadding(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      HintText(
                          themeManager: themeManager.isDarkMode,
                          text:
                              "Please fill out the following form in-order  to Sign up. Please Note that all fields are Mandatory and must be filled out!"),
                      SectionHeading(
                        text: "Personal Info",
                      ),
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Page1(
                                formKey: formKey,
                                model: model,
                                focusNode1: focusNode1,
                                focusNode2: focusNode2,
                              ),
                              SectionHeading(
                                text: "Contact Info",
                              ),
                              Page2(
                                model: model,
                                formKey: formKey,
                                focusNode1: focusNode3,
                                focusNode2: focusNode4,
                                focusNode3: focusNode5,
                                focusNode4: focusNode6,
                              ),
                              SectionHeading(
                                text: "Authentcation Info",
                              ),
                              Page3(
                                model: model,
                                formKey: formKey,
                                focusNode1: focusNode7,
                                focusNode2: focusNode8,
                                focusNode3: focusNode9,
                              ),
                            ],
                          )),
                      model.isBusy
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20.0, top: 10),
                              child: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        themeManager.isDarkMode
                                            ? Colors.white
                                            : Colors.blue)),
                              ),
                            )
                          : MainButtons(
                              buttontext: "Sign Up",
                              textColor: Colors.cyan,
                              borderColor: Colors.cyan,
                              // btnIcon: Icon(
                              //   Icons.ac_unit_outlined,
                              //   color: Colors.white,
                              // ),
                              onpress: () {
                                if (!formKey.currentState.validate()) {
                                } else {
                                  formKey.currentState.save();
                                  model.signUp();
                                }
                              },
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
////////////////// Steps Action Buttons //////////////////
///////////////// Ie: Continue and Cancel ///////////////
////////////////////////////////////////////////////////
class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key key,
    @required this.themeManager,
    this.onStepContinue,
    this.onStepCancel,
    this.isBusy,
  }) : super(key: key);
  final isBusy;
  final ThemeManager themeManager;
  final Function onStepContinue;
  final Function onStepCancel;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, left: 10),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              isBusy
                  ? Container(
                      width: 90,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            themeManager.isDarkMode
                                ? Colors.white
                                : Colors.blue,
                          ),
                          strokeWidth: 5,
                        ),
                      ),
                    )
                  : Container(
                      height: 35,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: TextButton(
                          onPressed: onStepContinue,
                          child: const Text('NEXT',
                              style: TextStyle(color: Colors.white)))),
              SizedBox(width: 10),
              Container(
                  height: 35,
                  width: 90,
                  decoration: BoxDecoration(
                      color: themeManager.isDarkMode
                          ? Colors.white12
                          : Colors.black12,
                      borderRadius: BorderRadius.circular(30)),
                  child: TextButton(
                      onPressed: onStepCancel,
                      child: Text('CANCEL',
                          style: TextStyle(
                              color: themeManager.isDarkMode
                                  ? Colors.white
                                  : Colors.black54))))
            ]));
  }
}

///////////////////////////////////////////////////
////////////// Step Title ////////////////////////
/////////////////////////////////////////////////
class StepText extends StatelessWidget {
  const StepText({Key key, @required this.themeManager, this.text})
      : super(key: key);

  final ThemeManager themeManager;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.inter(
            color: themeManager.isDarkMode ? Colors.white : Colors.black));
  }
}
