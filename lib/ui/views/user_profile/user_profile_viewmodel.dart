import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/app/router.gr.dart';
import 'package:pro1/models/user.dart';
import 'package:pro1/services/authetication_service.dart';
import 'package:pro1/services/cloud_storage_service.dart';
import 'package:pro1/services/firestore_service.dart';
import 'package:pro1/services/logined_user.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserProfileViewModel extends ReactiveViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();
  final _firestoreService = locator<FirestoreService>();
  final _cloudStorageService = locator<CloudStorageService>();
  final _currentUser = locator<LoginedUser>();
  bool isLoading = false;
  bool isVerifyingNumber = false;
  CurrentUser get currentUser => _currentUser.currentUser;
  bool get isCurrentUserBusy => _currentUser.isBusy;

  File _selectedImage;
  File get selectedImage => _selectedImage;
  final picker = ImagePicker();

  /// for sliding the phone number verification panel when verified
  AnimationController slideController;

  setIsVerifyingNumber(bool value) {
    isVerifyingNumber = value;
    notifyListeners();
  }

  Future selectImage() async {
    try {
      await _bottomSheetService
          .showBottomSheet(
        title: "Profile image.",
        description: "Do you want to change your Profile image",
        confirmButtonTitle: "Change Picture",
        cancelButtonTitle: "Go back",
      )
          .then((value) async {
        if (value != null && value.confirmed) {
          final pickedFile = await picker.getImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            _selectedImage = File(pickedFile.path);
            await uploadImage();
            notifyListeners();
          } else {
            await _bottomSheetService.showBottomSheet(
                title: "No image selected.",
                description: "Please Select an image to upload");
          }
        } else if (value != null && value.confirmed == false) {}
      });
    } catch (e) {
      await _bottomSheetService.showBottomSheet(
        title: "Permission Denied.",
        description: e.message,
      );
    }
  }

  Future<void> uploadImage() async {
    _currentUser.setBusy(true);
    var storageResult;
    storageResult = await _cloudStorageService.uploadImage(
      imageToUpload: _selectedImage,
      title: 'profile_image',
    );
    if (storageResult is String) {
      await _bottomSheetService.showBottomSheet(
        title: 'Cound not upload image',
        description: storageResult,
      );
    }
    notifyListeners();
    return _currentUser.setBusy(false);
  }

  Future updateUserProfileInfo(
      {String password, String shopName, String shopAddress}) async {
    if (shopAddress == "" || shopName == "") {
      await _bottomSheetService.showBottomSheet(
        title: 'Atention',
        description:
            "Please note that Shop Name and Shop Address cannot be submitted empty",
      );
      return;
    }
    if ((password == null || password == "") &&
        shopName == currentUser.shopName &&
        shopAddress == currentUser.shopAddress) {
      print("Nothings Changes");
      return;
    }
    isLoading = true;
    notifyListeners();
    var passResult;
    var profileResult;
    if (password != null &&
        password != "" &&
        shopName == currentUser.shopName &&
        shopAddress == currentUser.shopAddress) {
      print("Password Reset");
      passResult = await _authenticationService.resetPasswordByProvidingPass(
          pass: password);
    } else if (password == null || password == "") {
      print("Profile Reset");
      currentUser.shopName = shopName;
      currentUser.shopAddress = shopAddress;
      profileResult = await _firestoreService.updateUserAddresses(currentUser);
    } else {
      print("Password and profile reset");
      currentUser.shopName = shopName;
      currentUser.shopAddress = shopAddress;
      passResult = await _authenticationService.resetPasswordByProvidingPass(
          pass: password);
      profileResult = await _firestoreService.updateUserAddresses(currentUser);
    }
    isLoading = false;
    notifyListeners();
    if (passResult is String) {
      await _bottomSheetService.showBottomSheet(
        title: 'Cound not update Profile',
        description: passResult,
      );
    } else if (profileResult is String) {
      await _bottomSheetService.showBottomSheet(
        title: 'Cound not update Profile',
        description: profileResult,
      );
    } else {
      await _bottomSheetService.showBottomSheet(
        title: 'Successfull',
        description: "Profile Successfully Updated",
      );
    }
  }

  Future<void> verifyPhoneNumber() async {
    setIsVerifyingNumber(true);
    // await Future.delayed(Duration(seconds: 2));
    var result = await _authenticationService.verifyPhoneNumber();
    if (result is bool) {
      if (result) {
        await slideController.forward();
        _currentUser.currentUser.isNumberVerified = true;
        slideController.dispose();
        notifyListeners();
      } else
        setIsVerifyingNumber(false);
    } else if (result is String)
      await _bottomSheetService.showBottomSheet(
          title: "Sorry", description: result, confirmButtonTitle: "Ok");
    setIsVerifyingNumber(false);
  }

  Future signOut() async {
    await _bottomSheetService
        .showBottomSheet(
            title: "Logout",
            description: "Do you really want to Logout",
            confirmButtonTitle: "Confirm",
            cancelButtonTitle: "Cancel")
        .then((value) async {
      if (value.confirmed) {
        isLoading = true;
        notifyListeners();
        await Future.delayed(Duration(milliseconds: 1500));
        await FirebaseAuth.instance.signOut();
        await _navigationService.replaceWith(Routes.loginView);
      }
    });
  }

  getAchievment({type, double number}) {
    int num;
    if (type == "totalSales")
      num = currentUser.achievments.totalSales;
    else if (type == "totalProductsSoled")
      num = currentUser.achievments.totalProductsSoled;
    else if (type == "totalDaysAppUsed")
      num = currentUser.achievments.totalDaysAppUsed;
    if (number != null) num = number.toInt();
    if (num > 999 && num < 1000000) {
      return (num / 1000).toStringAsFixed(2) +
          'K'; // convert to K for number from > 1000 < 1 million
    } else if (num > 1000000) {
      return (num / 1000000).toStringAsFixed(1) +
          'M'; // convert to M for number from > 1 million
    } else if (num < 900) {
      return num.toString(); // if value < 1000, nothing to do
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_currentUser];
}
