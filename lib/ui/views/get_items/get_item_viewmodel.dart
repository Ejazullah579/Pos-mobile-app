import 'package:pro1/app/locator.dart';
import 'package:pro1/enums/bottom_sheet_type.dart';
import 'package:pro1/models/achievments.dart';
import 'package:pro1/models/self_product.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/services/local_database_service.dart';
import 'package:pro1/services/logined_user.dart';
import 'package:pro1/services/search_searvice.dart';
import 'package:pro1/services/shared_prefrences_service.dart';
import 'package:pro1/services/test_data.dart';
import 'package:stacked/stacked.dart';
import 'package:pro1/models/user.dart';
import 'package:stacked_services/stacked_services.dart';

class GetItemViewModel extends BaseViewModel {
  // final NavigationService _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _sharedPrefrencesService = locator<SharedPrefrencesService>();
  final _globalService = locator<GlobalService>();
  final _searchService = locator<SearchService>();
  final _currentUser = locator<LoginedUser>();
  final _localDatabaseService = locator<LocalDatabaseService>();

  GlobalService get globalService => _globalService;
  CurrentUser get currentUser => _currentUser.currentUser;
  List<Product> _productList = [];
  String _id;
  String get id => _id;
  List get productList => _productList;
  bool showWalkThrough = false;
  // int counter = 1;

  set setId(val) {
    _id = val;
  }

  bool _isSearching = false;
  bool get isSearching => this._isSearching;

  set isSearching(bool value) {
    this._isSearching = value;
    notifyListeners();
  }

  void handleReadyLogic() async {
    showWalkThrough =
        await _sharedPrefrencesService.getIsFirstTimeInScannerView();
    notifyListeners();
  }

  setWalkThrough() {
    _sharedPrefrencesService.setIsFirstTimeInScannerView(value: false);
  }

  /// keys for walk through are not properly initialized first so refreshing it after being visible
  void refreshWalkThrough() async {
    await Future.delayed(Duration(milliseconds: 7000));
    showWalkThrough = true;
    notifyListeners();
  }

  /// returns true if product is found and
  /// false if product is not found

  addProduct({String productId, SelfProduct selfProduct}) async {
    bool check = isDuplicateItem(productId);
    isSearching = true;
    if (selfProduct != null) {
      productList.add(new Product(counter: 1, selfProduct: selfProduct));
      notifyListeners();
      return true;
    }

    if (!check) {
      var product = await _searchService.getProduct(productId: productId);
      if (product is SelfProduct && !isDuplicateItem(productId)) {
        productList.add(new Product(counter: 1, selfProduct: product));
        notifyListeners();
        return true;
      } else
        // productList.add(new Product(
        //     counter: 1,
        //     selfProduct: SelfProduct.noValues(
        //         productId: productId, userId: currentUser.id)));
        isSearching = false;
      return false;

      // counter++;
    }
    isSearching = false;
    return false;
    // for testing purpose
    //  productList.add(new Product(
    //     counter: 1,
    //     selfProduct: SelfProduct(
    //         productId: productId,
    //         userId: currentUser.id,
    //         productName: "dumm",
    //         salePrice: 50,
    //         purchasePrice: 60)));
    // notifyListeners();
  }

  bool isDuplicateItem(String productId) {
    if (productList != null) {
      for (int i = 0; i < productList.length; i++) {
        if (productList[i].selfProduct.productId == productId) {
          return true; //UnComment thi
        }
      }
      return false;
    }
    return false;
  }

  void removeAllProducts() async {
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
          _productList.clear();
          print("Products List Cleared}");
          notifyListeners();
        }
      }
    });
  }

  double calculateTotal() {
    double total = 0;
    for (int i = 0; i < productList.length; i++) {
      total += productList[i].selfProduct.salePrice * productList[i].counter;
    }

    return double.parse(total.toStringAsFixed(3));
  }

  double calculateDiscountedTotal() {
    double total = 0;
    for (int i = 0; i < productList.length; i++) {
      total += productList[i].selfProduct.salePrice * productList[i].counter;
    }
    if (globalService.applyDiscount &&
        globalService.discountPercentage != 0 &&
        globalService.discountValue != 0 &&
        globalService.discountValue < total) {
      return double.parse(
          (total - (total * globalService.discountPercentage / 100))
              .toStringAsFixed(3));
    } else {
      return double.parse(total.toStringAsFixed(3));
    }
  }

  Future removeProduct(index) async {
    await _bottomSheetService
        .showBottomSheet(
            title: "Delete?",
            description:
                "Are you sure you want to Delete ${_productList[index].selfProduct.productName}",
            confirmButtonTitle: "Confirm",
            cancelButtonTitle: "Cancel")
        .then((value) {
      if (value != null) {
        if (value.confirmed) {
          if (index < productList.length) {
            _productList.removeAt(index);
          }
          notifyListeners();
        }
      }
    });
  }

  void incrementCounter(int index) {
    productList[index].counter += 1;
    notifyListeners();
  }

  void decrementCounter(int index) {
    if (productList[index].counter > 1) {
      productList[index].counter -= 1;
    }
    notifyListeners();
  }

  updateValues(DateTime date, double amount) async {
    _localDatabaseService.addDailyTransaction(
        date: date,
        amount: amount,
        totalProductsSoled: getTotalNumberOfProductsSoled());
    // _currentUser.currentUser.achievments.totalSales += amount.round();
    Achievments achievments = await _sharedPrefrencesService.getAchievments();
    await _sharedPrefrencesService.setAchievments(
        totalSales: achievments.totalSales + amount.toInt(),
        totalProductsSoled:
            achievments.totalProductsSoled + getTotalNumberOfProductsSoled());
    print("Entry Added to Database");
    print(getTotalNumberOfProductsSoled());
  }

  /// will show bottom sheet of product list
  Future showRecipt(model) async {
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.recipt,
      customData: model,
    );
  }

  int getTotalNumberOfProductsSoled() {
    int products = 0;
    for (int i = 0; i < productList.length; i++) {
      products += _productList[i].counter;
    }
    return products;
  }
}
