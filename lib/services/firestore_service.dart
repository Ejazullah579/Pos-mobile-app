import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ntp/ntp.dart';
import 'package:pro1/models/sponsor_add.dart';
import 'package:pro1/models/self_product.dart';
import 'package:pro1/models/subscription.dart';
import 'package:pro1/models/transaction.dart' as transaction;
import 'package:pro1/services/logined_user.dart';
import 'package:pro1/models/user.dart';
import 'package:pro1/app/locator.dart';

import 'local_database_service.dart';

class FirestoreService {
  CollectionReference _users =
      FirebaseFirestore.instance.collection('seller-accounts');
  CollectionReference _sponsorAdds =
      FirebaseFirestore.instance.collection('sponsor_adds');
  final LoginedUser _currentUser = locator<LoginedUser>();
  final _localDatabaseService = locator<LocalDatabaseService>();

////////////////////////////////////////////////////////////////////////////////
//////////////////////// User Collection Queries //////////////////////////////
//////////////////////////////////////////////////////////////////////////////
  Future createUser(CurrentUser user) async {
    try {
      // await _users.doc(user.id).set(user.toJson());
      await _users.doc(user.id).set(user.toJson());
      var dateNow = await NTP.now();
      var sub = Subscription(
          userId: _currentUser.currentUser.id,
          startDate: dateNow.toIso8601String(),
          endDate: dateNow.add(Duration(days: 7)).toIso8601String());
      await addSubscription(subscription: sub, docName: "Trial");
      _currentUser.subscription = sub;
      var sponsorAdds = await gettAllSponsorAdds();
      if (sponsorAdds is List<SponsorAdd>)
        _currentUser.sponsorAdds = sponsorAdds;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _users.doc(uid).get();
      ///// setting user products
      var selfProductData =
          await _users.doc(uid).collection("user_products").get();
      _currentUser.selfProductList = selfProductData.docs
          .map((e) => SelfProduct.fromJson(e.data()))
          .toList();
      var sponsorAdds = await gettAllSponsorAdds();
      if (sponsorAdds is List<SponsorAdd>)
        _currentUser.sponsorAdds = sponsorAdds;
      ///// setting user subscription
      _currentUser.subscription = await getSubscription(userId: uid);

      return CurrentUser.fromData(userData.data());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future updateUserAddresses(CurrentUser user) async {
    try {
      await _users
          .doc(user.id)
          .update({"shopName": user.shopName, "shopAddress": user.shopAddress});
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateUserImageInfo(CurrentUser user) async {
    try {
      await _users.doc(user.id).update(
          {"imageFileName": user.imageFileName, "imageUrl": user.imageUrl});
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateUserAchievments(CurrentUser user) async {
    try {
      await _users
          .doc(user.id)
          .update({"achievments": user.achievments.toJson()});
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateUserPhoneNumberStatus() async {
    try {
      await _users
          .doc(_currentUser.currentUser.id)
          .update({"isNumberVerified": true});
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
////////////////////////////////////////////////////////////////////////////////
//////////////////////// User_product Collection Queries //////////////////////
//////////////////////////////////////////////////////////////////////////////

  Future addProduct(SelfProduct product) async {
    try {
      var _userProducts = this
          ._users
          .doc(_currentUser.currentUser.id)
          .collection("user_products");
      var checkId = await _userProducts
          .where("productId", isEqualTo: product.productId)
          .get();
      var checkName = await _userProducts
          .where("productName", isEqualTo: product.productName)
          .get();
      if (checkId.docs.length >= 1 || checkName.docs.length >= 1) {
        return checkId.docs.length >= 1 && checkName.docs.length == 0
            ? "Sorry, this Id is already registered. Please generate or scan a new Unique id to register your product"
            : checkName.docs.length >= 1 && checkId.docs.length == 0
                ? "Sorry, this product name already exists. Try providing a Unique name"
                : "Please generate or scan a new Unique id and provide a Unique name. Thank you";
      } else
        await _userProducts
            .doc(product.productId)
            .set(product.toJson())
            .then((value) {});
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future updateProduct(SelfProduct product, bool nameChanged) async {
    try {
      if (nameChanged) {
        var _userProducts = this
            ._users
            .doc(_currentUser.currentUser.id)
            .collection("user_products");
        var checkName = await _userProducts
            .where("productName", isEqualTo: product.productName)
            .get();

        if (checkName.docs.length >= 1)
          return "Sorry, this product name already exists. Try providing a Unique name";
      }
      var _userProduct = this
          ._users
          .doc(_currentUser.currentUser.id)
          .collection("user_products");
      await _userProduct.doc(product.productId).set(product.toJson());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future getAllSelfProducts() async {
    try {
      var _userProducts = this
          ._users
          .doc(_currentUser.currentUser.id)
          .collection("user_products");
      var result = await _userProducts.get();

      return result.docs.map((e) => SelfProduct.fromJson(e.data())).toList();
    } catch (e) {
      return e.message;
    }
  }

  Future getSpecificSelfProduct(String productName) async {
    try {
      var _userProducts = this
          ._users
          .doc(_currentUser.currentUser.id)
          .collection("user_products");
      var result = await _userProducts
          .where("productName", isEqualTo: productName)
          .get();

      return result.docs.map((e) => SelfProduct.fromJson(e.data())).toList();
    } catch (e) {
      return e.message;
    }
  }

  Future deleteSelfProduct(String productId) async {
    try {
      var _userProducts = this
          ._users
          .doc(_currentUser.currentUser.id)
          .collection("user_products");
      await _userProducts.doc(productId).delete();
      return true;
    } catch (e) {
      return e.message;
    }
  }

  Future deleteAllSelfProduct() async {
    try {
      await _users
          .doc(_currentUser.currentUser.id)
          .collection("user_products")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      return true;
    } catch (e) {
      return e.message;
    }
  }

  Future generateId() async {
    return _users.doc().id;
  }

  ////////////////////////////////////////////////
  //////// user daily history update ////////////
  //////////////////////////////////////////////
  Future<void> addDailyTransactionHistory() async {
    try {
      transaction.Transaction lastTransaction =
          await _localDatabaseService.getLastWeeklyTransactions();
      // print(lastTransaction.date);
      var _userTransaction = this
          ._users
          .doc(_currentUser.currentUser.id)
          .collection("transaction_history");
      await _userTransaction
          .doc(lastTransaction.date.toString().substring(0, 10))
          .set(lastTransaction.toJson());
    } catch (e) {
      print("Firestore Error: $e");
      return e;
    }
  }

  Future<List<transaction.Transaction>> getAllDailyTransactionHistory() async {
    try {
      var _userTransaction = this
          ._users
          .doc(_currentUser.currentUser.id)
          .collection("transaction_history");
      var result = await _userTransaction.get();
      return result.docs
          .map((e) => transaction.Transaction.fromJson(e.data()))
          .toList();
    } catch (e) {
      return e.message;
    }
  }
  ////////////////////////////////////////////////
  //////// Global Products //////////////////////
  //////////////////////////////////////////////

  Future addGlobalProduct(SelfProduct product) async {
    CollectionReference _globalProducts = FirebaseFirestore.instance
        .collection(_currentUser.currentUser.shopType + "-products");
    try {
      var checkId = await _globalProducts
          .where("productId", isEqualTo: product.productId)
          .get();
      var checkName = await _globalProducts
          .where("productName", isEqualTo: product.productName)
          .get();
      if (checkId.docs.length >= 1 || checkName.docs.length >= 1) {
        return checkId.docs.length >= 1 && checkName.docs.length == 0
            ? "Sorry, this Id is already registered. Please generate or scan a new Unique id to register your product"
            : checkName.docs.length >= 1 && checkId.docs.length == 0
                ? "Sorry, this product name already exists. Try providing a Unique name"
                : "Please generate or scan a new Unique id and provide a Unique name. Thank you";
      } else
        await _globalProducts
            .doc(product.productId)
            .set(product.toJson())
            .then((value) {});
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future searchGlobalProduct({String productId}) async {
    CollectionReference _globalProducts = FirebaseFirestore.instance
        .collection(_currentUser.currentUser.shopType + "-products");
    try {
      var product;
      var result = await _globalProducts.doc(productId).get();
      if (result.data() is Map) product = SelfProduct.fromJson(result.data());
      return product ?? false;
    } catch (e) {
      return e.message;
    }
  }

  ////////////////////////////////////////////////
  //////// Sponsar Adds Section /////////////////
  //////////////////////////////////////////////
  Future gettAllSponsorAdds() async {
    try {
      var value = await _sponsorAdds.get();
      var result =
          value.docs.map((e) => SponsorAdd.fromJson(e.data())).toList();
      // print("here ${result.length}");
      return result;
    } catch (e) {
      return e.message;
    }
  }

  Future addSponsorAdd(SponsorAdd add) async {
    try {
      var result = await _sponsorAdds.add(add.toJson());
      return result;
    } catch (e) {
      return e.message;
    }
  }

  //////////////////////////////////////////////
  ////////// Subscription Section /////////////
  ////////////////////////////////////////////

  Future getSubscription({String userId}) async {
    try {
      var _subscription = this._users.doc(userId).collection("subscription");
      var result = await _subscription.get();
      var lastObj = result.docs.elementAt(result.docs.length - 1);
      // print(lastObj.data());
      return Subscription.fromData(lastObj.data());
    } catch (e) {
      return e.message;
    }
  }

  Future addSubscription({Subscription subscription, String docName}) async {
    try {
      _users
          .doc(_currentUser.currentUser.id)
          .collection("subscription")
          .doc(docName)
          .set(subscription.toJson());
      return true;
    } catch (e) {
      return e.message;
    }
  }
}
