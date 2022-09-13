import 'package:pro1/app/locator.dart';
import 'package:pro1/models/self_product.dart';
import 'package:pro1/services/firestore_service.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/services/logined_user.dart';
import 'package:pro1/utils/save_qrcode.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddProductViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _globalService = locator<GlobalService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _currrntUser = locator<LoginedUser>();
  get currrntUser => _currrntUser.currentUser;
  GlobalService get globalService => _globalService;

  bool isBusyGettingId = false;

  bool isGlobalProduct = false;
  String productId = "Product ID";
  String productName;
  double purchasePrice;
  double salePrice;

  /// for updating product
  String orignalProductName;

  setProductId(String value) {
    productId = value;
    notifyListeners();
  }

  setIsGlobalProduct(bool value) {
    productId = "Product ID";
    isGlobalProduct = value;
    notifyListeners();
  }

  Future addProduct() async {
    var result, product;
    if (productId.contains("Product ID")) {
      result = "Please generate a Unique id inorder to register your product.";
    } else {
      setBusy(true);
      product = SelfProduct(
          productName: productName.toLowerCase(),
          purchasePrice: purchasePrice,
          salePrice: salePrice,
          userId: _currrntUser.currentUser.id,
          image: "",
          productId: productId);
      if (!isGlobalProduct)
        result = await _firestoreService.addProduct(product);
      else
        result = await _firestoreService.addGlobalProduct(product);
      setBusy(false);
      notifyListeners();
    }
    if (result is String) {
      await _bottomSheetService.showBottomSheet(
          title: "Could not add product", description: result);
    } else {
      _currrntUser.addSingleSelfProduct(product);
      if (globalService.shouldGenerateQrImage) {
        toQrImageData(product.productId, product.productName);
      }
      await _bottomSheetService.showBottomSheet(
          title: "Succesfull", description: "Product successfully added");
    }
  }

  Future updateProduct() async {
    var result;
    setBusy(true);
    var product = SelfProduct(
        productName: productName.toLowerCase(),
        purchasePrice: purchasePrice,
        salePrice: salePrice,
        userId: _currrntUser.currentUser.id,
        productId: productId);
    result = await _firestoreService.updateProduct(
        product, !(productName == orignalProductName));
    setBusy(false);
    notifyListeners();

    if (result is String) {
      return await _bottomSheetService.showBottomSheet(
          title: "Could not add product", description: result);
    } else {
      _currrntUser.setSingleSelfProductList(
          product: product, productId: product.productId);
      await _bottomSheetService.showBottomSheet(
          title: "Succesfull", description: "Product successfully Updated");
    }
    return product;
  }

  generateUniqueId() async {
    isBusyGettingId = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    productId = await _firestoreService.generateId();
    isBusyGettingId = false;
    notifyListeners();
    return productId;
  }
}
