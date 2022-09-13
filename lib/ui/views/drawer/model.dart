import 'package:firebase_auth/firebase_auth.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/app/router.gr.dart';
import 'package:pro1/models/user.dart';
import 'package:pro1/services/logined_user.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DrawerModel extends ReactiveViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _currentUser = locator<LoginedUser>();
  final _navigationService = locator<NavigationService>();
  LoginedUser get currentUser => _currentUser;

  Future signOut() async {
    await _bottomSheetService
        .showBottomSheet(
            title: "Logout",
            description: "Do you really want to Logout",
            confirmButtonTitle: "Confirm",
            cancelButtonTitle: "Cancel")
        .then((value) async {
      if (value != null) {
        if (value.confirmed) {
          setBusy(true);
          notifyListeners();
          await Future.delayed(Duration(milliseconds: 1500));
          await FirebaseAuth.instance.signOut();
          setBusy(false);
          await _navigationService.replaceWith(Routes.loginView);
        }
      }
    });
  }

  @override
  // TODO: implement reactiveServices
  List<ReactiveServiceMixin> get reactiveServices => [_currentUser];
}
