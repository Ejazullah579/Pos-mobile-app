import 'package:pro1/app/locator.dart';
import 'package:pro1/services/authetication_service.dart';
import 'package:pro1/ui/views/drawer/drawer_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  String _userName;
  String get username => _userName;
  String _userpass;
  String get userpass => _userpass;
  bool _showPassword = true;
  bool get showPassword => this._showPassword;

  set showPassword(bool value) {
    this._showPassword = value;
    notifyListeners();
  }

  set setPass(String newpass) {
    _userpass = newpass;
  }

  set setUserName(String newusername) {
    _userName = newusername;
  }

  Future login() async {
    setBusy(true);
    var result = await _authenticationService.loginWithEmail(
      email: username.trim(),
      password: userpass,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateWithTransition(DrawerView(),
            transition: NavigationTransition.RightToLeft);
      } else {
        await _bottomSheetService.showBottomSheet(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _bottomSheetService.showBottomSheet(
        title: 'Login Failure',
        description: result,
      );
    }
  }

  Future resetPassword(String email) async {
    setBusy(true);
    var result =
        await _authenticationService.resetPassword(email: email.trim());
    setBusy(false);
    if (result is String) {
      return _bottomSheetService.showBottomSheet(
          title: "Invalid Email", description: result);
    } else
      return _bottomSheetService.showBottomSheet(
          title: "Email Successfully Sent",
          description:
              "Please check your inbox and follow the link to reset your password");
  }
}
