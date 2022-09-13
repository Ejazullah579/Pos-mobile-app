import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/ui/views/drawer/main_screen.dart';
import 'package:pro1/ui/views/drawer/menu_screen.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class DrawerView extends StatefulWidget {
  DrawerView({Key key}) : super(key: key);

  @override
  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  final ZoomDrawerController _drawerController = ZoomDrawerController();
  GlobalService _globalService = locator<GlobalService>();
  var themeManger;

  @override
  void initState() {
    super.initState();
    _globalService.drawerController = _drawerController;
    themeManger = getThemeManager(context).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_globalService.drawerController.isOpen())
          _globalService.drawerController.close();
        else if (_globalService.currentPage != 0) {
          _globalService.drawerController.open();
          await Future.delayed(Duration(milliseconds: 300));
          _globalService.currentPage = 0;
          await Future.delayed(Duration(milliseconds: 300));
          _globalService.drawerController.close();
        } else if (_globalService.currentPage == 0) {
          await BottomSheetService()
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
      child: ZoomDrawer(
        controller: _drawerController,
        style: DrawerStyle.Style1,
        menuScreen: MenuScreen(),
        mainScreen: MainScreeen(),
        borderRadius: 24.0,
        mainScreenScale: 0.2,
        showShadow: true,
        angle: 0.0,
        backgroundColor: Colors.grey[200].withOpacity(0.5),
        slideWidth: MediaQuery.of(context).size.width * .5,
        openCurve: Curves.decelerate,
        closeCurve: Curves.easeIn,
      ),
    );
  }
}
