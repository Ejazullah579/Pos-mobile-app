import 'package:pro1/app/locator.dart';
import 'package:pro1/app/router.gr.dart';
import 'package:pro1/services/authetication_service.dart';
import 'package:pro1/ui/views/drawer/drawer_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignupViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final NavigationService _navigationService = locator<NavigationService>();

  String firstName = "";

  String lastName = "";

  String phoneNumber = "";

  String dateOfBirth = "";

  String city = "Select your city";

  String shopType = "Select shop type";

  String shopName = "";

  String homeAddress = "";

  String shopAddress = "";

  String userPass = "";

  String rePass = "";

  String userEmail = "";

  setCity(value) {
    city = value;
    notifyListeners();
  }

  setShopType(value) {
    shopType = value;
    notifyListeners();
  }

  Future signUp() async {
    if (userPass != rePass) {
      return await _bottomSheetService.showBottomSheet(
        title: 'Passwords Donot Match',
      );
    } else if (shopType == "Select shop type") {
      return await _bottomSheetService.showBottomSheet(
        title: 'Please Select the type of shop you own .',
      );
    } else if (city == "Select your city") {
      return await _bottomSheetService.showBottomSheet(
        title: 'Please Select your city',
      );
    }
    setBusy(true);

    var result = await _authenticationService.signUpWithEmail(
      email: userEmail,
      password: userPass,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: "92" + phoneNumber.substring(1),
      dateOfBirth: dateOfBirth,
      city: city,
      homeAddress: homeAddress,
      shopAddress: shopAddress,
      shopType: shopType,
      shopName: shopName,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateWithTransition(DrawerView(),
            transition: NavigationTransition.RightToLeft);
        // showTrialBottomSheet();
      } else {
        await _bottomSheetService.showBottomSheet(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _bottomSheetService.showBottomSheet(
        title: 'Sign Up Failure',
        description: result,
      );
    }
  }

  showTrialBottomSheet() async {
    await Future.delayed(Duration(milliseconds: 600));
    await _bottomSheetService.showBottomSheet(
        title: "Congratulaions!",
        description:
            "You have been given 7 days free trial of our pro version. Thank you for trusting us and we will keep providing best and reliable services to our valuable costumers.");
  }
}
