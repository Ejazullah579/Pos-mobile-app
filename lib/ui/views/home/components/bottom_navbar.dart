import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/app/router.gr.dart' as router;
import 'package:pro1/services/global_service.dart';
import 'package:pro1/services/search_searvice.dart';
import 'package:pro1/ui/components/info_box.dart';
import 'package:pro1/ui/components/popUpInfo.dart';
import 'package:pro1/ui/views/Settings/settings_view.dart';
import 'package:pro1/ui/views/home/components/navbar_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  var controller;
  final List<Widget> items;
  // NOTE: You CAN declare your own model here instead of `PersistentBottomNavBarItem`.
  final ValueChanged<int> onItemSelected;

  BottomNavBar(
      {Key key,
      this.selectedIndex,
      this.items,
      this.onItemSelected,
      this.controller})
      : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final SearchService searchService = locator<SearchService>();
  final GlobalService globalService = locator<GlobalService>();

  bool isopened;
  @override
  void initState() {
    isopened = false;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //////// for opening menu in search item view /////
  void callbacK() {
    setState(() {
      globalService.setMaxval = 135;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);

    return ViewModelBuilder.reactive(
      onModelReady: (model) => model.globalService.updateVal = callbacK,
      viewModelBuilder: () => NavBarViewModel(),
      builder: (context, model, child) => GestureDetector(
        onVerticalDragUpdate: (details) {
          // print(details);
          if (details.delta.dy < -8) {
            setState(() {
              model.globalService.setMaxval = 135.0;
            });
          } else if (details.delta.dy > 8) {
            //bottom Swipe
            if (model.globalService.maxval >= 50) {
              setState(() {
                model.globalService.setMaxval = 50.0;
              });
              isopened = false;
            }
          }
        },
        child: SafeArea(
          bottom: true,
          child: Container(
            color: themeManager.isDarkMode ? Colors.black : Colors.white,
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.fastLinearToSlowEaseIn,
              height: model.globalService.maxval,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      tileMode: TileMode.clamp,
                      colors: themeManager.isDarkMode
                          ? <Color>[Colors.grey[850], Colors.grey[850]]
                          : <Color>[Colors.indigo, Colors.blue]),
                  borderRadius: globalService.currentPage != 1
                      ? BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14))
                      : BorderRadius.zero),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    width: double.infinity,
                    height: 53.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: widget.items.map((item) {
                        var index = widget.items.indexOf(item);
                        return Flexible(
                          child: GestureDetector(
                            onTap: index != 3
                                ? () {
                                    widget.onItemSelected(index);
                                    // if (index != 1) {
                                    //   if (model.globalService.isCameraOn) {
                                    //     model.globalService.controller
                                    //         .pauseCamera();
                                    //     model.globalService.isCameraOn = false;
                                    //   }
                                    // }
                                    // if (index == 1) {
                                    //   model.globalService.isCameraOn = true;
                                    //   if (model.globalService.controller
                                    //               .toString() ==
                                    //           "null"
                                    //       ? false
                                    //       : true) {
                                    //     model.globalService.controller
                                    //         .resumeCamera();
                                    //   }
                                    // }
                                  }
                                : () {
                                    if (!isopened) {
                                      setState(() {
                                        model.globalService.setMaxval = 180.0;
                                      });
                                      isopened = true;
                                    } else if (isopened) {
                                      setState(() {
                                        model.globalService.setMaxval = 50.0;
                                      });
                                      isopened = false;
                                    }
                                    if (_controller.isCompleted) {
                                      _controller.reverse();
                                    } else {
                                      _controller.forward();
                                    }
                                  },
                            onLongPress: () {
                              // if (model.globalService.isCameraOn) {
                              //   model.globalService.controller.pauseCamera();
                              //   model.globalService.isCameraOn2 = false;
                              // }
                              if (index == 3) {
                                NavigationService().navigateWithTransition(
                                  SettingsView(),
                                  duration: Duration(milliseconds: 700),
                                  transition: NavigationTransition.RightToLeft,
                                );
                              }
                            },
                            child: index != 3
                                ? _buildItem(
                                    item, widget.selectedIndex == index, index)
                                : AnimatedBuilder(
                                    animation: _controller.view,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: _controller.value * 2 * 3.14,
                                        child: child,
                                      );
                                    },
                                    child: _buildItem(item,
                                        widget.selectedIndex == index, index)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  ////////////// Fake Search Field
                  FakeSearchField(
                    globalService: model.globalService,
                    themeManager: themeManager,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 0, left: 20),
                              width: 120,
                              child: Text(
                                "Discount",
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    decoration: TextDecoration.none),
                              )),
                          Positioned(
                              top: -15,
                              right: -30,
                              child: PopUpInfo(
                                heroTag: "navbar_discount_info",
                                iconColor: Colors.white,
                                text: [
                                  "A shortcut to enable discount functionality for your valuable customers.",
                                  "Before using it, you must set the minimum amount and discount percentage in the Settings.",
                                  "To set the values, long press the settings button to go to settings.",
                                  "Enable Discount button and set the two fields."
                                ],
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Material(
                          color: Colors.transparent,
                          child: Switch(
                              activeTrackColor: Colors.tealAccent[300],
                              activeColor: Colors.tealAccent[700],
                              inactiveTrackColor: themeManager.isDarkMode
                                  ? Colors.white30
                                  : Colors.black26,
                              value: model.globalService.applyDiscount,
                              onChanged: (value) {
                                model.setApplyDiscount(value);
                              }),
                        ),
                      ),
                    ],
                  ),

                  // Container(
                  //   height: 50,
                  //   width: double.infinity,
                  //   margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(30)),
                  //   child: FlatButton(
                  //     color: Colors.transparent,
                  //     onPressed: () {
                  //       _formKey.currentState.save();
                  //     },
                  //     child: Text(
                  //       "Apply",
                  //       style: GoogleFonts.inter(
                  //           color: Colors.black87,
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.w500),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////
  ////////// Main Page Navigation icons builder ///////
  ////////////////////////////////////////////////////

  Widget _buildItem(Widget item, bool isSelected, int index) {
    return Container(
      alignment: Alignment.center,
      height: 60.0,
      margin: EdgeInsets.only(left: isSelected ? 10 : 0),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          index != 3
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  height: 36.0,
                  width: isSelected ? 86 : 50,
                  alignment: Alignment.center,
                  // padding: isSelected
                  //     ? EdgeInsets.symmetric(horizontal: 0, vertical: 1)
                  //     : EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black26 : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  //return only item if render issue risses on different screens
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          item,
                          isSelected
                              ? Text(
                                  index == 0
                                      ? " Home"
                                      : index == 1
                                          ? " scan"
                                          : " search",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      decoration: TextDecoration.none),
                                )
                              : Container()
                        ],
                      )
                    ],
                  ),
                )
              : item,
        ],
      ),
    );
  }
}

class FakeSearchField extends ViewModelWidget<NavBarViewModel> {
  FakeSearchField({
    Key key,
    @required this.globalService,
    @required this.themeManager,
  }) : super(key: key);

  final GlobalService globalService;
  final ThemeManager themeManager;
  @override
  Widget build(BuildContext context, NavBarViewModel model) {
    return GestureDetector(
      onTap: () async {
        // if (globalService.isCameraOn) {
        //   globalService.controller.pauseCamera();
        // }
        // if (model.isFirstTime) {
        globalService.goToSearchItemView();
        await Future.delayed(Duration(milliseconds: 100));
        model.isFirstTime = false;
        // }
        globalService.searchNode.requestFocus();
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Material(
          elevation: 2,
          color: Colors.white,
          shadowColor: Colors.white,
          borderRadius: BorderRadius.circular(35),
          textStyle: TextStyle(),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.search, color: Colors.black54)),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(width: 2, color: Colors.black38))),
                    child: Text(
                        model.searchService.searchValue != null &&
                                model.searchService.searchValue.length != 0
                            ? model.searchService.searchValue
                            : "Type to Search",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
