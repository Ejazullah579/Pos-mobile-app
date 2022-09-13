import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/ui/views/get_items/get_items_view.dart';
import 'package:pro1/ui/views/home/components/bottom_navbar.dart';
import 'package:pro1/ui/views/search_result/search_result_view.dart';
import 'package:pro1/services/connectivity_service.dart';
import 'package:pro1/enums/connectivity_status.dart';
import 'package:provider/provider.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'home_view.dart';

class FullBottomNavbar extends StatefulWidget {
  const FullBottomNavbar({Key key}) : super(key: key);

  @override
  _FullBottomNavbarState createState() => _FullBottomNavbarState();
}

class _FullBottomNavbarState extends State<FullBottomNavbar>
    with SingleTickerProviderStateMixin {
  int index = 0;
  bool hideNavebar;
  AnimationController _controller;
  PersistentTabController _controller2;
  final GlobalService globalService = locator<GlobalService>();
  @override
  void initState() {
    super.initState();

    hideNavebar = false;
    _controller2 = PersistentTabController(initialIndex: 0);
    globalService.animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0))
          ..addListener(() {
            if (globalService.animationController != null) {
              if (globalService.animationController.isCompleted)
                globalService.setHideNavebar = true;
              else if (globalService.animationController.isDismissed)
                globalService.setHideNavebar = false;
            }
            setState(() {});
          })
          ..forward();
    globalService.setHideNavebar = false;
  }

  @override
  void dispose() {
    _controller2.dispose();
    _controller.dispose();
    globalService.animationController.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      HomeView(),
      GetItemsView(),
      SearchResultView(),
    ];
  }

  List<Widget> _navBarsItems() {
    return [
      Icon(Icons.home, color: Colors.white),
      Icon(Icons.shop, color: Colors.white),
      Icon(Icons.search, color: Colors.white),
      Icon(Icons.settings, color: Colors.white),
    ];
  }

  void callbacK() {
    setState(() {
      _controller2.index = 2;
    });
    globalService.setMaxvalOutside();
  }

  void callbacK2() {
    setState(() {
      _controller2.index = _controller2.index;
    });
  }

  AnimationController getController() {
    return _controller;
  }

  @override
  Widget build(BuildContext context) {
    globalService.goToSearchItemView = callbacK;
    globalService.updateCurrentPage = callbacK2;
    var maxWidth = MediaQuery.of(context).size.width;
    var maxHeight = MediaQuery.of(context).size.height;
    return Container(
      height: maxHeight,
      width: maxWidth,
      child: StreamProvider<ConnectivityStatus>.value(
          value:
              locator<ConnectivityService>().connectionStatusController.stream,
          builder: (context, child) =>
              // if (snapshot.hasData) {
              //   if (snapshot.data == ConnectivityStatus.Wifi ||
              //       snapshot.data == ConnectivityStatus.Cellular) {

              Container(
                child: PersistentTabView(
                  controller: _controller2,
                  navBarHeight: 50,
                  floatingActionButton: globalService.showHideNavbarButton
                      ? Container(
                          transform: Matrix4.translationValues(
                              -(maxWidth * 0.5) + 40, 50, 0),
                          child: GestureDetector(
                            onTap: () {
                              if (globalService.animationController.isCompleted)
                                globalService.animationController.reverse();
                              else if (globalService
                                  .animationController.isDismissed)
                                globalService.animationController.forward();
                            },
                            // onVerticalDragEnd: (details) {
                            //   print(details.primaryVelocity);
                            //   if (details.primaryVelocity < -5) {
                            //     if (globalService.animationController.isDismissed)
                            //       globalService.animationController.forward();
                            //   } else if (details.primaryVelocity > 10) {
                            //     if (globalService.animationController.isCompleted)
                            //       globalService.animationController.reverse();
                            //   }
                            // },
                            child: Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: getThemeManager(context).isDarkMode
                                      ? Colors.grey[800].withOpacity(0.5)
                                      : Colors.blue[800].withOpacity(0.5),
                                  shape: BoxShape.circle),
                              child: AnimatedIcon(
                                icon: AnimatedIcons.menu_close,
                                progress: globalService.animationController,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  hideNavigationBar: globalService.hideNavbar,
                  onWillPop: () {
                    if (_controller2.index != 0) {
                      setState(() {
                        _controller2.index = 0;
                      });
                    } else if (_controller2.index == 0) {
                      BottomSheetService()
                          .showBottomSheet(
                              title: "Exit?",
                              description: "Are you sure you want to Exit?",
                              confirmButtonTitle: "Confirm",
                              cancelButtonTitle: "cancel")
                          .then((value) {
                        if (value != null) {
                          if (value.confirmed) {
                            SystemNavigator.pop(animated: true);
                          }
                        }
                      });
                    }
                    return;
                  },
                  backgroundColor: Colors.transparent,
                  itemCount: _navBarsItems()
                      .length, // This is required in case of custom style! Pass the number of items for the nav bar.
                  screens: _buildScreens(),
                  confineInSafeArea: true,
                  stateManagement: true,
                  resizeToAvoidBottomInset: true,
                  screenTransitionAnimation: ScreenTransitionAnimation(
                      duration: Duration(milliseconds: 200),
                      animateTabTransition: true),

                  handleAndroidBackButtonPress: true,
                  onItemSelected: (val) {
                    setState(() {
                      index = val;
                    }); // This is required to update the nav bar if Android back button is pressed
                  },
                  //////// Custom Nav Bar.....
                  customWidget: BottomNavBar(
                    items: _navBarsItems(),
                    selectedIndex: _controller2.index,
                    controller: getController(),
                    onItemSelected: (index) {
                      globalService.currentPage = index;
                      setState(() {
                        _controller2.index = index;
                      });
                    },
                  ),
                  navBarStyle:
                      ///////// For Custom Navbar
                      NavBarStyle.custom,
                ),
              )
          // } else if (snapshot.data == ConnectivityStatus.Offline) {
          //   return MaterialPageRoute();

          ),
    );
  }
}

// class CustomClipPath extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(size.width / 2, size.height);
//     path.lineTo(size.width, 0.0);
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
