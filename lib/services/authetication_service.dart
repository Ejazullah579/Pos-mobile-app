import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/enums/bottom_sheet_type.dart';
import 'package:pro1/models/achievments.dart';
import 'package:pro1/models/user.dart';
import 'package:pro1/services/logined_user.dart';
import 'package:pro1/services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final LoginedUser _currentUser = locator<LoginedUser>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
///////////////////////////////////////////////////////////////
  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(user.user);
      ///// if error change it to user only
      return user.user != null;
    } catch (e) {
      return e.message;
    }
  }

//////////////////////////////////////////////////////////////
  Future signUpWithEmail(
      {@required String email,
      @required String password,
      String firstName,
      String shopType,
      String lastName,
      String phoneNumber,
      String dateOfBirth,
      String city,
      String homeAddress,
      String shopAddress,
      String shopName,
      String imageFileName,
      String imageUrl}) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // for adding user profile info
      String id = _firebaseAuth.currentUser.uid.toString();
      _currentUser.currentUser = CurrentUser(
          id: id,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          dateOfBirth: dateOfBirth,
          city: city,
          imageFileName: imageFileName,
          imageUrl: imageUrl,
          homeAddress: homeAddress,
          shopAddress: shopAddress,
          shopType: shopType,
          shopName: shopName,
          country: "Pakistan",
          userType: "user",
          email: email,
          isNumberVerified: false,
          achievments: Achievments(
              totalDaysAppUsed: 1, totalProductsSoled: 0, totalSales: 0),
          accountActivationDate: DateTime.now().toString().substring(0, 10));
      await _firestoreService.createUser(_currentUser.currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future resetPasswordByProvidingPass({String pass}) async {
    try {
      return await _firebaseAuth.currentUser.updatePassword(pass);
    } catch (e) {
      return e.message;
    }
  }

  Future resetPassword({String email}) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("error" + e.message);
      return e.message;
    }
  }

  Future verifyPhoneNumber() async {
    var completer = Completer<bool>();
    bool _isVerificationBottomSheetShow = false;
    try {
      final PhoneVerificationCompleted verified = (AuthCredential authResult) {
        print("Auth completed");
      };

      final PhoneVerificationFailed verificationfailed =
          (FirebaseAuthException authException) async {
        await _bottomSheetService.showBottomSheet(
            title: "Error",
            description: authException.message,
            confirmButtonTitle: "Ok");
        completer.complete(false);
      };

      final PhoneCodeSent smsSent =
          (String verificationId, [int forceResend]) async {
        _isVerificationBottomSheetShow = true;
        Function verificationFunction = _firebaseAuth.signInWithCredential;
        Function updateUserNumberStatus =
            _firestoreService.updateUserPhoneNumberStatus;
        await _bottomSheetService.showCustomSheet(
            variant: BottomSheetType.verification,
            barrierDismissible: false,
            customData: [
              verificationId,
              verificationFunction,
              updateUserNumberStatus
            ]).then((value) async {
          if (value != null) {
            if (value.confirmed == null) {
              await _bottomSheetService.showBottomSheet(
                  title: "Sorry",
                  description: value.responseData,
                  confirmButtonTitle: "Ok");
              completer.complete(false);
            } else if (value.confirmed) {
              {
                await _bottomSheetService.showBottomSheet(
                    title: "Congratulation",
                    description: "Your phone number was successfully verified.",
                    confirmButtonTitle: "Ok");
                completer.complete(true);
              }
            } else if (value.confirmed == false) {
              await _bottomSheetService.showBottomSheet(
                  title: "Sorry",
                  description:
                      "The Provided code was wrong. Please provide a valid code and try again",
                  confirmButtonTitle: "Ok");
              completer.complete(false);
            }
          } else {
            await _bottomSheetService.showBottomSheet(
                title: "Sorry",
                description:
                    "An error occured due to unknown source. Please try again later",
                confirmButtonTitle: "Ok");
            completer.complete(false);
          }
        });
      };

      final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
        // if (_isVerificationBottomSheetShow) NavigationService().back();
      };

      var result = await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+" + _currentUser.currentUser.phoneNumber,
          timeout: const Duration(seconds: 100),
          verificationCompleted: verified,
          verificationFailed: verificationfailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout);
    } catch (e) {
      completer.complete(true);
      return e.message;
    }
    return completer.future;
  }

////////////////////////////////////////////////////////////
  Future<bool> isUserLoggedIn() async {
    var user = _firebaseAuth.currentUser;

    if (await _populateCurrentUser(user) is String) {
      return false;
    }
    return user != null;
  }

  Future _populateCurrentUser(User user) async {
    if (user != null) {
      try {
        var result = await _firestoreService.getUser(user.uid);
        return _currentUser.currentUser = result;
      } catch (e) {
        return e.toString();
      }
    }
  }
}
