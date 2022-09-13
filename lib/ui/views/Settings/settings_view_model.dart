import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends BaseViewModel {
  final GlobalService _globalService = locator<GlobalService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  GlobalService get globalService => _globalService;
  BottomSheetService get bottomSheetService => _bottomSheetService;

  setApplyDiscount(value) {
    globalService.setApplyDiscount(value);
    notifyListeners();
  }

  setHideNavbar(value) {
    globalService.setHideNavbar(value);
    notifyListeners();
  }

  bool _isLight = false;
  bool get isLight => _isLight;
  set setIsLight(val) {
    _isLight = val;
    notifyListeners();
  }

  updateTheme() {
    notifyListeners();
  }
}
