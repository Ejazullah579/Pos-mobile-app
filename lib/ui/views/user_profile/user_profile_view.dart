import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/app/router.gr.dart';
import 'package:pro1/ui/components/hinttext.dart';
import 'package:pro1/ui/views/user_profile/user_profile_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class UserProfileView extends StatefulWidget {
  UserProfileView({Key key}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView>
    with TickerProviderStateMixin {
  final FocusNode _phoneNumberNode = FocusNode();
  //////// Controllers
  AnimationController slideController;
  AnimationController editProfileController;
  AnimationController phoneVerificationController;
  AnimationController transactionController;
  AnimationController scaleController;
  ///// Text Controllers
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    editProfileController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    phoneVerificationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    transactionController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    editProfileController.addListener(() {
      setState(() {});
    });
    transactionController.addListener(() {
      setState(() {});
    });
    phoneVerificationController.addListener(() {
      setState(() {});
    });
    scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400))
          ..forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    editProfileController.dispose();
    transactionController.dispose();
    // _passwordController.dispose();
    // _shopAddressController.dispose();
    // _shopNameController.dispose();
    // _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxheight = MediaQuery.of(context).size.height;
    final maxwidth = MediaQuery.of(context).size.width;

    final themeManager = getThemeManager(context).isDarkMode;
    return SafeArea(
      child: ViewModelBuilder.reactive(
        viewModelBuilder: () => UserProfileViewModel(),
        onModelReady: (model) {
          // _passwordController=model.currentUser.password
          if (!model.currentUser.isNumberVerified) {
            slideController = AnimationController(
                vsync: this, duration: Duration(milliseconds: 500))
              ..addListener(() async {
                setState(() {});
              });
            model.slideController = slideController;
          }
          _shopNameController.text = model.currentUser.shopName;
          _phoneNumberController.text = model.currentUser.phoneNumber;
          _shopAddressController.text = model.currentUser.shopAddress;
          if (!model.currentUser.isNumberVerified)
            phoneVerificationController.forward();
          else
            transactionController.forward();
        },
        builder: (context, model, child) => Scaffold(
            backgroundColor: !themeManager ? Colors.white : Colors.black,
            resizeToAvoidBottomInset: true,
            body: GestureDetector(
              onTap: () => {
                if (!FocusScope.of(context).hasPrimaryFocus)
                  {FocusScope.of(context).unfocus()}
              },
              child: Stack(
                children: [
                  CustomScrollView(
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    clipBehavior: Clip.hardEdge,
                    shrinkWrap: true,
                    slivers: [
                      SliverAppBar(
                        expandedHeight: maxheight * 0.3,
                        backgroundColor:
                            themeManager ? Colors.black : Colors.white,
                        actions: [
                          GestureDetector(
                            onTap: () {
                              return model.signOut();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 15,
                                    right: 13,
                                    child: Icon(
                                      Icons.logout,
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                        flexibleSpace: Container(
                          height: maxheight * 0.3,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  stops: [0.0, 0.75],
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.lightBlue,
                                    !themeManager ? Colors.white : Colors.black,
                                  ])),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (!model.isCurrentUserBusy)
                                  model.selectImage();
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 0, top: 20),
                                height: maxheight * 0.25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: model.isCurrentUserBusy
                                    ? ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 6,
                                            ),
                                          ),
                                          WaitText(
                                            text: "Please Wait",
                                          ),
                                        ],
                                      )
                                    : model.currentUser.imageUrl == null ||
                                            model.currentUser.imageUrl == "" ||
                                            model.currentUser.imageUrl == "null"
                                        ? Container(
                                            height: maxheight * 0.15,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white24),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                Center(
                                                  child: Icon(
                                                    Icons.add_a_photo,
                                                    size: 50,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4),
                                                  child: WaitText(
                                                    text:
                                                        "Tap Here To\nUpload an Image",
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : CachedNetworkImage(
                                            imageUrl:
                                                model.currentUser.imageUrl,
                                            placeholder: (context, url) =>
                                                Container(
                                              height: 100,
                                              alignment: Alignment.center,
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 6,
                                                    ),
                                                  ),
                                                  WaitText(text: "Almost There")
                                                ],
                                              ),
                                            ),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Hero(
                                                  tag: "profile_pic",
                                                  child: Container(
                                                    width: maxheight * 0.3,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            alignment: Alignment
                                                                .center,
                                                            image:
                                                                imageProvider)),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: maxheight * 0.05,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              offset:
                                                                  Offset.zero,
                                                              blurRadius: 10,
                                                              spreadRadius: 5)
                                                        ]),
                                                    child: Icon(
                                                      Icons.add_a_photo,
                                                      color: themeManager
                                                          ? Colors.white
                                                          : Colors.white,
                                                      size: 40,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                              ),
                            ),
                          ),
                        ),
                      ),
/////////////////////////////////////////////////////////////
////////// Name SLiver Widget //////////////////////////////
///////////////////////////////////////////////////////////
                      SliverAppBar(
                        expandedHeight: maxheight * 0.08,
                        backgroundColor:
                            themeManager ? Colors.black : Colors.white,
                        leading: Container(),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              return NavigationService()
                                  .navigateTo(Routes.notificationCenterView);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 15,
                                    right: 13,
                                    child: Icon(
                                      Icons.notifications,
                                      size: 28,
                                      color: themeManager
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                  Positioned(
                                    top: 17,
                                    right: 14,
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                        flexibleSpace: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: maxwidth * 0.12),
                            child: Text(
                              model.currentUser.firstName,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: themeManager
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ),
////////////////////////////////////////////////////
/////  Phone Verification Tab  ///////////////////////////
//////////////////////////////////////////////////
                      model.currentUser.isNumberVerified
                          ? SliverToBoxAdapter()
                          : SliverToBoxAdapter(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                transform: Matrix4.translationValues(
                                    model.slideController.value * maxwidth,
                                    0,
                                    0),
                                color: themeManager
                                    ? Colors.white10
                                    : Colors.black12,
                                margin: EdgeInsets.only(
                                    bottom: 10, left: 3, right: 3),
                                child: Column(
                                  children: [
                                    PanelInfo(
                                      themeManager: themeManager,
                                      panelText: "Verify Number",
                                      icon: Icon(Icons.money),
                                      controller: phoneVerificationController,
                                      callBacks: (int value) {
                                        if (phoneVerificationController
                                            .isDismissed)
                                          scaleController.reverse();
                                        else if (phoneVerificationController
                                                .isCompleted &&
                                            transactionController.isDismissed &&
                                            editProfileController.isDismissed)
                                          scaleController.forward();
                                      },
                                    ),
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.bounceOut,
                                      height:
                                          phoneVerificationController.value *
                                              95,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: ListView(
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          ////////////////////////////////////
                                          /// From Global Component Folder //
                                          //////////////////////////////////
                                          HintText(
                                              themeManager: themeManager,
                                              text:
                                                  "Please verify your number"),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: EditProfileTextFormField(
                                                    hintText: "Phone Number ",
                                                    isEnable: false,
                                                    node: _phoneNumberNode,
                                                    controller:
                                                        _phoneNumberController,
                                                    icon: Icon(Icons.shop),
                                                    // controller: _shopNameController,
                                                    themeManager: themeManager),
                                              ),
                                              SizedBox(width: 10),
                                              TransactionButton(
                                                buttonText: "Verify",
                                                isBusy: model.isVerifyingNumber,
                                                onPress: () =>
                                                    model.verifyPhoneNumber(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
////////////////////////////////////////////////////
/////  Transaction Tab  ///////////////////////////
//////////////////////////////////////////////////
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          color: themeManager ? Colors.white10 : Colors.black12,
                          margin:
                              EdgeInsets.only(bottom: 10, left: 3, right: 3),
                          child: Column(
                            children: [
                              PanelInfo(
                                themeManager: themeManager,
                                panelText: "Transaction",
                                icon: Icon(Icons.money),
                                controller: transactionController,
                                callBacks: (int value) {
                                  if (!model.currentUser.isNumberVerified) {
                                    if (!editProfileController.isCompleted &&
                                        phoneVerificationController
                                            .isDismissed) {
                                      if (value == 1)
                                        scaleController.forward();
                                      else if (value == 0)
                                        scaleController.reverse();
                                    }
                                  }
                                },
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.bounceOut,
                                height: transactionController.value * 120,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    ////////////////////////////////////
                                    /// From Global Component Folder //
                                    //////////////////////////////////
                                    HintText(
                                        themeManager: themeManager,
                                        text:
                                            "You can generate total sales slip on yearly, monthly and even weekly bases.Select one of the following"),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TransactionButton(
                                          buttonText: "Yearly",
                                          onPress: () {},
                                        ),
                                        TransactionButton(
                                          buttonText: "Monthly",
                                          onPress: () {},
                                        ),
                                        TransactionButton(
                                          buttonText: "Weekly",
                                          onPress: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
////////////////////////////////////////////////////////
/////  Edit Profile Info Tab  /////////////////////////
//////////////////////////////////////////////////////
                      SliverToBoxAdapter(
                        child: Container(
                          color: themeManager ? Colors.white10 : Colors.black12,
                          margin:
                              EdgeInsets.only(bottom: 10, left: 3, right: 3),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: PanelInfo(
                                  themeManager: themeManager,
                                  panelText: "Edit Profile",
                                  icon: Icon(Icons.edit),
                                  controller: editProfileController,
                                  callBacks: (int value) {
                                    if (!model.currentUser.isNumberVerified) {
                                      if (!transactionController.isCompleted &&
                                          phoneVerificationController
                                              .isDismissed) {
                                        if (value == 1)
                                          scaleController.forward();
                                        else if (value == 0)
                                          scaleController.reverse();
                                      }
                                    } else {
                                      if (scaleController.isDismissed)
                                        scaleController.forward();
                                      else if (scaleController.isCompleted)
                                        scaleController.reverse();
                                    }
                                  },
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.bounceOut,
                                height: editProfileController.value * 350,
                                padding: EdgeInsets.symmetric(horizontal: 18),
                                child: Form(
                                  key: _formKey,
                                  child: ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      ////////////////////////////////////
                                      /// From Global Component Folder //
                                      //////////////////////////////////
                                      HintText(
                                          themeManager: themeManager,
                                          text:
                                              "Please only edit those fields which you wants to change"),
                                      EditProfileTextFormField(
                                          hintText: "Password",
                                          icon: Icon(Icons.security),
                                          autoValidate: true,
                                          validator: (data) {
                                            if (_passwordController.text !=
                                                    null &&
                                                _passwordController.text !=
                                                    null) {
                                              MultiValidator([
                                                RequiredValidator(
                                                  errorText:
                                                      "Password Required",
                                                ),
                                                MinLengthValidator(8,
                                                    errorText:
                                                        "Minimum 8 characters required"),
                                              ]);
                                            }
                                          },
                                          controller: _passwordController,
                                          themeManager: themeManager),
                                      EditProfileTextFormField(
                                          hintText: "Shop Name",
                                          icon: Icon(Icons.shop),
                                          controller: _shopNameController,
                                          themeManager: themeManager),
                                      EditProfileTextFormField(
                                          hintText: "Shop Address",
                                          icon: Icon(Icons.place),
                                          controller: _shopAddressController,
                                          themeManager: themeManager),
                                      TransactionButton(
                                        buttonText: "Update Profile",
                                        onPress: () {
                                          if (!_formKey.currentState.validate())
                                            return;
                                          model.updateUserProfileInfo(
                                              password:
                                                  _passwordController.text,
                                              shopName:
                                                  _shopNameController.text,
                                              shopAddress:
                                                  _shopAddressController.text);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // SliverList(
                      //     delegate: SliverChildBuilderDelegate((context, index) {
                      //   return Container(
                      //     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      //     height: 100,
                      //     color: Colors.blueAccent,
                      //   );
                      // }, childCount: 20))
                    ],
                  ),
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: model.isLoading
                          ? Container(
                              height: 70,
                              color:
                                  themeManager ? Colors.black54 : Colors.white,
                              padding: EdgeInsets.only(bottom: 20),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : !_phoneNumberNode.hasFocus
                              ? Stack(
                                  children: [
                                    AnimatedBuilder(
                                      animation: transactionController,
                                      builder: (context, child) =>
                                          ScaleTransition(
                                        scale: scaleController,
                                        child: child,
                                      ),
                                      child: Container(
                                        width: maxwidth,
                                        padding: EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AchievmentWidget(
                                              icon: Icon(Icons.add_chart),
                                              text: model.getAchievment(
                                                  type: "totalSales"),
                                              toolTipMessage: "Total Sales",
                                            ),
                                            AchievmentWidget(
                                              icon: Icon(Icons.inventory),
                                              text: model.getAchievment(
                                                  type: "totalProductsSoled"),
                                              toolTipMessage:
                                                  "Total Products Soled",
                                            ),
                                            AchievmentWidget(
                                              icon: Icon(Icons.money),
                                              text: model.getAchievment(
                                                  number: model
                                                          .currentUser
                                                          .achievments
                                                          .totalSales /
                                                      model
                                                          .currentUser
                                                          .achievments
                                                          .totalDaysAppUsed),
                                              toolTipMessage: "Average Sales",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                    ),
                ],
              ),
            )),
      ),
    );
  }
}

class WaitText extends StatelessWidget {
  const WaitText({Key key, this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
            color: getThemeManager(context).isDarkMode
                ? Colors.white54
                : Colors.black54,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

class AchievmentWidget extends StatelessWidget {
  const AchievmentWidget({
    Key key,
    this.icon,
    this.text,
    this.toolTipMessage,
  }) : super(key: key);

  final Icon icon;
  final String text;
  final String toolTipMessage;

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context).isDarkMode;
    return Tooltip(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration:
          BoxDecoration(color: themeManager ? Colors.white10 : Colors.black12),
      waitDuration: Duration(milliseconds: 100),
      textStyle: TextStyle(color: themeManager ? Colors.white : Colors.black),
      message: toolTipMessage,
      child: Container(
          width: 90,
          decoration: BoxDecoration(
              color: themeManager ? Colors.white10 : Colors.black12,
              borderRadius: BorderRadius.circular(10)),
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon.icon,
                color: Colors.orange,
                size: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                      color: !themeManager ? Colors.black : Colors.white),
                ),
              )
            ],
          )),
    );
  }
}

///////////////////////////////////////////////////////
/////////// Panel Information ////////////////////////
/////////////////////////////////////////////////////

class PanelInfo extends StatelessWidget {
  const PanelInfo({
    Key key,
    @required this.themeManager,
    @required this.controller,
    this.panelText,
    this.icon,
    this.callBacks,
  }) : super(key: key);

  final bool themeManager;
  final AnimationController controller;
  final String panelText;
  final Icon icon;
  final Function callBacks;

  @override
  Widget build(BuildContext context) {
    final bool isPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                icon.icon,
                color: !themeManager ? Colors.black : Colors.white60,
              )),
          Text(
            panelText,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: !themeManager ? Colors.black : Colors.white60,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (controller.isCompleted) {
                if (callBacks != null) callBacks(1);
                controller.reverse();
              } else {
                if (callBacks != null) callBacks(0);
                controller.forward();
              }
            },
            child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                color: !themeManager ? Colors.black : Colors.white60,
                progress: controller),
          )
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////
//////////// Transaction Panel Button ////////////////
/////////////////////////////////////////////////////

class TransactionButton extends StatelessWidget {
  const TransactionButton({Key key, this.buttonText, this.onPress, this.isBusy})
      : super(key: key);
  final String buttonText;
  final Function onPress;
  final isBusy;

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 44,
      width: maxWidth * 0.27,
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(5)),
      child: isBusy ?? false
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.amber,
              onPressed: onPress,
              child: Text(buttonText,
                  style: GoogleFonts.inter(
                      fontSize: maxWidth * 0.04,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87.withOpacity(0.7))),
            ),
    );
  }
}

class EditProfileTextFormField extends StatelessWidget {
  const EditProfileTextFormField(
      {Key key,
      @required this.themeManager,
      @required this.hintText,
      this.icon,
      this.controller,
      this.validator,
      this.autoValidate,
      this.isEnable = true,
      this.node})
      : super(key: key);

  final bool themeManager;
  final String hintText;
  final Icon icon;
  final controller;
  final Function validator;
  final bool autoValidate;
  final bool isEnable;
  final FocusNode node;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: themeManager ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(5),
        shadowColor: themeManager ? Colors.black : Colors.black38,
        elevation: themeManager ? 10 : 5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 10),
              child: Icon(
                icon.icon,
                color: themeManager ? Colors.white60 : Colors.black87,
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 7),
                padding: EdgeInsets.only(top: 0),
                height: 23,
                width: 1,
                child: ColoredBox(
                  color: themeManager ? Colors.white60 : Colors.black87,
                )),
            Expanded(
              child: Container(
                height: 45,
                child: TextFormField(
                  controller: controller,
                  enabled: isEnable,
                  focusNode: node ?? FocusNode(),
                  validator: validator,
                  autovalidateMode: autoValidate == true
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                      color: themeManager ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                      hintText: hintText,
                      contentPadding:
                          EdgeInsets.only(left: 8, right: 15, top: 0),
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.inter(
                          color:
                              themeManager ? Colors.white60 : Colors.black87)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
