import 'package:pro1/app/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PurchaseSubscriptionViewModel extends BaseViewModel {
  var _navigationService = locator<NavigationService>();
  var _snackbarService = locator<SnackbarService>();

  int _selectedIndex = 2;
  get selectedIndex => this._selectedIndex;
  List<int> prices = [100, 300, 500];

////////////// for busy indicators
  bool isBusyGooglePayIndicator = false;
  bool isBusyJazzCashIndicator = false;

  setIsBusyGooglePayIndicator(bool value) {
    isBusyGooglePayIndicator = value;
    notifyListeners();
  }

  setIsBusyJazzCashIndicator(bool value) {
    isBusyJazzCashIndicator = value;
    notifyListeners();
  }

  set selectedIndex(value) {
    this._selectedIndex = value;
    notifyListeners();
  }

  Future<void> payWithGooglePay() async {
    setIsBusyGooglePayIndicator(true);
    await Future.delayed(Duration(seconds: 2));
    _navigationService.back();
    return _snackbarService.showSnackbar(
        title: "Congratulation",
        message:
            "You have successfully subscribed our pro version for 1 month. Thank you for staying with us.");
  }

  Future<void> payWithJazzCash() async {
    setIsBusyJazzCashIndicator(true);
    await Future.delayed(Duration(seconds: 2));
    _navigationService.back();
    return _snackbarService.showSnackbar(
        title: "Congratulation",
        message:
            "You have successfully subscribed our pro version for 1 month. Thank you for staying with us.");
  }
}
