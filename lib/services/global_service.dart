import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/shared_prefrences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class GlobalService with ReactiveServiceMixin {
  SharedPrefrencesService _sharedPrefrencesService =
      locator<SharedPrefrencesService>();
  /////////////////// For Settings View : Discount info /////////////////////
  bool applyDiscount;
  double discountPercentage;
  double discountValue;

  /// testing
  ZoomDrawerController drawerController;

  setApplyDiscount(bool value) async {
    applyDiscount = value;
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool("apply_discount", value);
  }

  setDiscountValue(double value) async {
    discountValue = value;
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setDouble("discount_value", value);
  }

  setDiscountPercent(double value) async {
    discountPercentage = value;
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setDouble("discount_percent", value);
  }

  ////////// For Searching :SearchField /////////////////
  FocusNode searchNode;
  ///////// Signup View : elements//////////////////////
  TextEditingController con = TextEditingController();
  set conValue(val) {
    con.text = val;
    notifyListeners();
  }

  //// Generate qrImage
  bool shouldGenerateQrImage;

  setshouldGenerateQrImage() async {
    shouldGenerateQrImage = !shouldGenerateQrImage;
    _sharedPrefrencesService.setshouldGenerateQrImage(shouldGenerateQrImage);
    notifyListeners();
  }

  ///////// For Changing Page :Bottom Navbar ///////////
  AnimationController animationController;
  bool showHideNavbarButton;
  bool _hideNavbar = false;
  double _maxval = 50;
  int _currentPage = 0;
  int get currentPage => _currentPage;
  Function updateVal;
  Function updateCurrentPage;
  Function goToSearchItemView;
  double get maxval => _maxval;
  bool get hideNavbar => _hideNavbar;
  Function(int) setPage;

  set currentPage(int val) {
    _currentPage = val;
    setPage(val);
    notifyListeners();
  }

  set setMaxval(double val) {
    _maxval = val;
    notifyListeners();
  }

  set setHideNavebar(bool val) {
    _hideNavbar = val;
    notifyListeners();
  }

  setMaxvalOutside() {
    updateVal();
    notifyListeners();
  }

  setHideNavbar(bool value) async {
    if (value == false && hideNavbar) _hideNavbar = false;
    showHideNavbarButton = value;
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool("showHideNavbarButton", value);
  }

  ///////////////////////////////////////////////////////
  /////////////// For Camera : getItemView /////////////
  /////////////////////////////////////////////////////
  // QRViewController controller;
  // RxValue<bool> _isCameraOn = RxValue(initial: false);

  // bool get isCameraOn => _isCameraOn.value;
  // set isCameraOn(bool value) {
  //   _isCameraOn.value = value;
  // }

  // set isCameraOn2(bool value) {
  //   _isCameraOn.value = value;
  //   notifyListeners();
  // }
  ////////////////////////////////////////////////////

  GlobalService() {
    // listenToReactiveValues([_isCameraOn.value]);
  }
}
