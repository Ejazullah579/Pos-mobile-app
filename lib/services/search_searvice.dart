import 'package:flutter/cupertino.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/models/self_product.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'firestore_service.dart';
import 'logined_user.dart';

class SearchService with ReactiveServiceMixin {
  final _bottomSheetService = locator<BottomSheetService>();
  final _snackbarService = locator<SnackbarService>();
  final _currentUser = locator<LoginedUser>();
  final _firestoreService = locator<FirestoreService>();

//////////// For Getting Products info in Getitem view

  getProduct({String productId}) async {
    final userPrduct = await searchInUserProducts(productId);
    //// checking in UserProducts List
    if (userPrduct is SelfProduct)
      return userPrduct;
    //// checking in GlobalProducts List
    else {
      final result =
          await _firestoreService.searchGlobalProduct(productId: productId);
      if (result is SelfProduct)
        return result;
      else if (result is bool)
        return null;
      else if (result is String) {
        _snackbarService.showSnackbar(title: "Error !!", message: result);
        return null;
      }
    }
  }

  searchInUserProducts(String productId) {
    final List<SelfProduct> userProducts = _currentUser.selfProductList;
    var product;
    for (int i = 0; i < userProducts.length; i++) {
      if (userProducts[i].productId == productId) {
        product = userProducts[i];
        break;
      }
    }
    return product;
  }

//////////// For Searching Products info in search view
  RxValue<String> _searchValue = RxValue<String>();
  RxList<SelfProduct> _products = RxList<SelfProduct>();
  String get searchValue => _searchValue.value;
  RxList<SelfProduct> get products => _products;
  TextEditingController textController = TextEditingController();
  set products(value) {
    _products = value;
  }

  set setSearchValue(value) {
    _searchValue.value = value;
    notifyListeners();
  }

  /// Search based on product name
  drawData(searchvalue) {
    List<SelfProduct> product = _currentUser.selfProductList;
    if (products.length > 0) products.removeRange(0, products.length);
    if (searchvalue != null && searchvalue.length > 0) {
      for (int i = 0; i < _currentUser.selfProductList.length; i++) {
        if (product[i].productName.contains(searchvalue)) {
          products.add(product[i]);
        }
      }
    } else {
      if (products.length > 0) products.removeAt(0);
    }
    notifyListeners();
  }

  /// Search based on product name
  searchByName(searchvalue) {
    List<SelfProduct> product = _currentUser.selfProductList;
    List<SelfProduct> resultList = [];
    if (products.length > 0) products.removeRange(0, products.length);
    if (searchvalue != null && searchvalue.length > 0) {
      for (int i = 0; i < _currentUser.selfProductList.length; i++) {
        if (product[i].productName.contains(searchvalue)) {
          resultList.add(product[i]);
        }
      }
    } else {
      if (products.length > 0) products.removeAt(0);
    }
    return resultList;
  }

  deleteAllData() async {
    await _bottomSheetService
        .showBottomSheet(
            title: "Delete",
            description:
                "Are you sure you want to delete the current product list",
            cancelButtonTitle: "Cancel",
            confirmButtonTitle: "Confirm")
        .then((value) {
      if (value != null) {
        if (value.confirmed) {
          print("Products List Cleared}");
          textController.text = "";
          _products.clear();
          _searchValue.value = "";
          notifyListeners();
        }
      }
    });
  }

  SearchService() {
    listenToReactiveValues([_searchValue.value, _products.onChange]);
  }
}
