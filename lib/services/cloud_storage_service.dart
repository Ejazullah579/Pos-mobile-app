import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/firestore_service.dart';
import 'package:pro1/services/logined_user.dart';

class CloudStorageService {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final LoginedUser _currentUser = locator<LoginedUser>();
  Future uploadImage({
    @required File imageToUpload,
    @required String title,
  }) async {
    // var imageFileName =
    //     title + DateTime.now().millisecondsSinceEpoch.toString();
    var imageFileName = _currentUser.currentUser.id;

    try {
      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("/profile_images/" + imageFileName);
      String downloadUrl;
      await firebaseStorageRef.putFile(imageToUpload).then((snapshot) async {
        downloadUrl = await snapshot.ref.getDownloadURL();
        var url = downloadUrl.toString();
        return CloudStorageResult(
          imageUrl: url,
          imageFileName: imageFileName,
        );
      });
      print("Download" + downloadUrl.toString());
      // deleteImage();
      _currentUser.setProfileImage(
          imageName: imageFileName, url: downloadUrl.toString());

      await _firestoreService.updateUserImageInfo(_currentUser.currentUser);
    } catch (e) {
      return e.message;
    }
  }

  Future deleteImage() async {
    var imageFileName = _currentUser.currentUser.id;
    if (imageFileName == '' ||
        imageFileName == 'null' ||
        imageFileName == null) {
      return;
    }
    final Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child("/profile_images/" + imageFileName);

    await firebaseStorageRef.delete().then((value) {
      print("Successfully delt");
    }).catchError((error) => error.message);
    return true;
  }
}

class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;

  CloudStorageResult({this.imageUrl, this.imageFileName});
}
