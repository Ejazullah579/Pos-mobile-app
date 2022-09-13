import 'package:flutter/material.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/ui/components/hinttext.dart';
import 'package:pro1/ui/components/popUpInfo.dart';
import 'package:pro1/ui/views/Settings/settings_view_model.dart';
import 'package:pro1/ui/views/home/components/discount_info.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'components/settings_alert_box.dart';
import 'components/settings_heading.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with SingleTickerProviderStateMixin {
  final GlobalService _globalService = locator<GlobalService>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final maxheight = MediaQuery.of(context).size.height;
    final themeManager = getThemeManager(context).isDarkMode;
    setControllers(_valueController, _percentController, _globalService);
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Settings"),
        // ),
        backgroundColor: themeManager ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          child: ViewModelBuilder.reactive(
            viewModelBuilder: () => SettingsViewModel(),
            onModelReady: (model) {
              if (model.globalService.applyDiscount)
                _controller.forward();
              else
                _controller.reverse();
            },
            builder: (context, model, child) => Container(
              height: maxheight,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView(
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  children: [
/////////////////////////////////////////////
////////// Display Section /////////////////
///////////////////////////////////////////
                    Container(
                      padding: EdgeInsets.only(bottom: 30, top: 20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: themeManager
                                      ? Colors.white12
                                      : Colors.black12,
                                  width: 1))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //////// local Component Folder
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SettingsHeading(text: "Display"),
                              Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: themeManager
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: () async {
                                    _globalService.drawerController.open();
                                    await Future.delayed(
                                        Duration(milliseconds: 300));
                                    _globalService.setPage(0);
                                    await Future.delayed(
                                        Duration(milliseconds: 300));
                                    _globalService.drawerController.close();
                                  },
                                ),
                              )
                            ],
                          ),
                          SettingsAlertBox(
                            maxheight: maxheight,
                            mainHeading: "Theme",
                            contentType: "theme",
                            onPress: () {
                              setState(() {});
                            },
                            subHeading: getThemeManager(context).isDarkMode
                                ? " Dark"
                                : " Light",
                            contentMainHeading: "Choose Theme",
                            contentFirstRadiotext: "Light",
                            contentSecondRadiotext: "Dark",
                            icon: Icon(Icons.brightness_high),
                          )
                        ],
                      ),
                    ),
/////////////////////////////////////////////
////////// Language Section ////////////////
///////////////////////////////////////////
                    Container(
                        padding: EdgeInsets.only(bottom: 20, top: 20),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: themeManager
                                        ? Colors.white12
                                        : Colors.black12,
                                    width: 1))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //////// local Component Folder
                              SettingsHeading(text: "Language"),
                              SettingsAlertBox(
                                maxheight: maxheight,
                                mainHeading: "App Language",
                                subHeading: "Default(English)",
                                contentMainHeading: "Choose Language",
                                contentFirstRadiotext: "English",
                                contentSecondRadiotext: "Urdu",
                                icon: Icon(Icons.language),
                              )
                            ])),
/////////////////////////////////////////////
/////// HideNavbar Section ///////////////////
///////////////////////////////////////////
                    Container(
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: themeManager
                                      ? Colors.white12
                                      : Colors.black12,
                                  width: 1))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SettingsHeading(text: "Buttons"),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "hide Navbar button?",
                                  style: TextStyle(
                                      color: themeManager
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 42),
                                  child: Switch(
                                      activeTrackColor: Colors.tealAccent[300],
                                      activeColor: Colors.tealAccent[700],
                                      inactiveTrackColor: themeManager
                                          ? Colors.white30
                                          : Colors.black26,
                                      value: model
                                          .globalService.showHideNavbarButton,
                                      onChanged: (value) {
                                        model.setHideNavbar(value);
                                      }),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
/////////////////////////////////////////////
/////// Discount Section ///////////////////
///////////////////////////////////////////
                    Container(
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: themeManager
                                      ? Colors.white12
                                      : Colors.black12,
                                  width: 1))),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //////// local Component Folder
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                        width: 140,
                                        child:
                                            SettingsHeading(text: "Discount")),
                                    Positioned(
                                        top: -15,
                                        right: -20,
                                        child: PopUpInfo(
                                          iconColor: Colors.grey,
                                          heroTag: "discount_info",
                                          text: [
                                            "Enable discount functionality to offer your valuable customers a unique discount.",
                                            "Before using it, you must set the minimum amount to avail discount and discount percentage first.",
                                            "Simply fill the below 2 fields and press 'enter'.",
                                            "Now whenever you enable this, your customers will recieve the defined percentage of discount from total when the discount value is meet.",
                                            "You can also enable or disable it from Drawer in home by swiping right."
                                          ],
                                        )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 42),
                                  child: Switch(
                                      activeTrackColor: Colors.tealAccent[300],
                                      activeColor: Colors.tealAccent[700],
                                      inactiveTrackColor: themeManager
                                          ? Colors.white30
                                          : Colors.black26,
                                      value: model.globalService.applyDiscount,
                                      onChanged: (value) {
                                        model.setApplyDiscount(value);
                                        if (value == false)
                                          _controller.reverse();
                                        else
                                          _controller.forward();
                                      }),
                                ),
                              ],
                            ),

                            AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.bounceOut,
                              height: 170 * _controller.value,
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: HintText(
                                      themeManager: themeManager,
                                      text:
                                          "Please note that you have to press Enter inorder to save the values",
                                    ),
                                  ),
                                  DiscountInfo(
                                    headingText: "Discount Value",
                                    formKey: _formKey,
                                    controller: _valueController,
                                    onEditingComplete: () async {
                                      if (_valueController.text.length == 0 ||
                                          _valueController.text == "") {
                                        await BottomSheetService().showBottomSheet(
                                            title: "Invalid Input",
                                            description:
                                                "You cannot submit the field empty.");
                                      } else if (_valueController.text
                                          .contains(new RegExp(r'[A-Z,a-z]'))) {
                                        await BottomSheetService().showBottomSheet(
                                            title: "Invalid Input",
                                            description:
                                                "Please provide valid information. This field should only consist of numbers.");
                                      } else {
                                        _globalService.setDiscountValue(
                                            double.parse(
                                                _valueController.text));
                                        await BottomSheetService().showBottomSheet(
                                            title: "Success! ",
                                            description:
                                                "Discount value has been set successfully");
                                      }
                                    },
                                  ),
                                  DiscountInfo(
                                    headingText: "Discount Percent",
                                    formKey: _formKey,
                                    controller: _percentController,
                                    onEditingComplete: () async {
                                      if (_percentController.text.length == 0 ||
                                          _percentController.text == "") {
                                        await BottomSheetService().showBottomSheet(
                                            title: "Invalid Input",
                                            description:
                                                "You cannot submit the field empty.");
                                      } else if (_percentController.text
                                          .contains(new RegExp(r'[A-Z,a-z]'))) {
                                        await BottomSheetService().showBottomSheet(
                                            title: "Invalid Input",
                                            description:
                                                "Please provide valid information. This field should only consist of numbers.");
                                      } else {
                                        _globalService.setDiscountPercent(
                                            double.parse(
                                                _percentController.text));
                                        await BottomSheetService().showBottomSheet(
                                            title: "Success! ",
                                            description:
                                                "Discount value has been set successfully");
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

setControllers(_valueController, _percentController, _globalService) {
  _valueController.text = _globalService.discountValue == 0
      ? null
      : _globalService.discountValue.toString();
  _percentController.text = _globalService.discountPercentage == 0
      ? null
      : _globalService.discountPercentage.toString();
}
