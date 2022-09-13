import 'package:pro1/app/locator.dart';
import 'package:pro1/models/self_product.dart';
import 'package:pro1/services/firestore_service.dart';
import 'package:pro1/services/logined_user.dart';
import 'package:pro1/services/search_searvice.dart';
import 'package:pro1/utils/save_qrcode.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EditProductViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _searchService = locator<SearchService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _currrntUser = locator<LoginedUser>();
  List<SelfProduct> get userProductList => _currrntUser.selfProductList;
  List<SelfProduct> selfProductList;

  int workingIndex = 0;
  bool isBusyDeletingProduct = false;
  set setisBusyDeletingProduct(value) {
    isBusyDeletingProduct = value;
    notifyListeners();
  }

  bool isBusyGeneratingQrcode = false;
  set setisBusyGeneratingQrcode(value) {
    isBusyGeneratingQrcode = value;
    notifyListeners();
  }

  ///// For Genrating all Qr image Dialouge
  bool isComplete = false;
  bool isStarted = false;
  bool isInProgress = false;
  double progress = 0;
  set setisComplete(value) {
    isComplete = value;
    notifyListeners();
  }

  set setisStarted(value) {
    isStarted = value;
    notifyListeners();
  }

  set setisInProgress(value) {
    isInProgress = value;
    notifyListeners();
  }

  generateAllQrImages() async {
    if (userProductList.length > 0) {
      setisComplete = false;
      progress = 0;
      setisStarted = true;
      setisInProgress = true;
      // var val = list.length * 10 / 100;
      for (int i = 0; i <= userProductList.length; i++) {
        await Future.delayed(Duration(milliseconds: 50));
        // if (i % val >= 0)
        progress = ((i * 10) / userProductList.length * 10);
        notifyListeners();
        print(progress);
        if (i != userProductList.length) {
          await toQrImageData(
              userProductList[i].productId, userProductList[i].productName);
        }
      }
      setisInProgress = false;
      setisComplete = true;
    }
  }

  ////////////////////////////////

  // String productId = "Product ID";
  // String productName;
  // double purchasePrice;
  // double salePrice;

  updateCurrentProduct(int index, product) {
    selfProductList[index] = product;
    notifyListeners();
  }

  Future getAllSelfProducts(String searchData) async {
    setBusy(true);
    var result;
    if (searchData == null || searchData == "") {
      result = await _firestoreService.getAllSelfProducts();
    } else
      result = await _searchService.searchByName(searchData);

    if (result is String) {
      _bottomSheetService.showBottomSheet(title: "Sorry", description: result);
    } else {
      selfProductList = result;
    }
    setBusy(false);
  }

  Future deleteSelfProduct({int index}) async {
    workingIndex = index;
    notifyListeners();
    var result;
    await _bottomSheetService
        .showBottomSheet(
            title: "Delete?",
            description: "Are you sure you want to delete this product",
            cancelButtonTitle: "cancel",
            confirmButtonTitle: "Confirm")
        .then((value) async {
      if (value != null) {
        if (value.confirmed) {
          setisBusyDeletingProduct = true;
          result = await _firestoreService
              .deleteSelfProduct(selfProductList[index].productId);
          _currrntUser.deleteSingleProduct(
              productId: selfProductList[index].productId);
          selfProductList.removeAt(index);
          setisBusyDeletingProduct = false;
        }
      }
    });
    notifyListeners();
    if (result is String) {
      _bottomSheetService.showBottomSheet(
          title: "Couldn't Delete Product", description: result);
    }
  }

  Future deleteAllSelfProducts() async {
    var result;
    await _bottomSheetService
        .showBottomSheet(
            title: "Delete products?",
            description:
                "Are you sure you want to delete all of your products. Please double check before confirming.",
            confirmButtonTitle: "Confirm",
            cancelButtonTitle: "Cancel")
        .then((value) async {
      if (value != null) {
        if (value.confirmed) {
          setBusy(true);
          result = await _firestoreService.deleteAllSelfProduct();
          selfProductList.clear();
          _currrntUser.deleteAllSelfProducts();
          setBusy(false);
        }
      }
    });

    if (result is String) {
      _bottomSheetService.showBottomSheet(
          title: "Couldn't Delete All Product", description: result);
    }
  }

  // Future addProduct() async {
  //   setBusy(true);
  //   var result = await _firestoreService.addProduct(SelfProduct(
  //       productName: productName,
  //       purchasePrice: purchasePrice,
  //       salePrice: salePrice,
  //       userId: _currrntUser.currentUser.id,
  //       productId: productId));
  //   setBusy(false);
  //   notifyListeners();
  //   if (result is String) {
  //     await _bottomSheetService.showBottomSheet(
  //         title: "Could not add product", description: result);
  //   } else {
  //     await _bottomSheetService.showBottomSheet(
  //         title: "SuccesFull", description: "Product successfully added");
  //   }
  // }

  generateQrCode(index) async {
    workingIndex = index;
    setisBusyGeneratingQrcode = true;
    await Future.delayed(Duration(seconds: 1));
    var product = selfProductList[index];
    await toQrImageData(product.productId, product.productName);
    setisBusyGeneratingQrcode = false;
  }
}
