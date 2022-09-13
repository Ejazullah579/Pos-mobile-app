import 'package:observable_ish/observable_ish.dart';
import 'package:pro1/models/self_product.dart';
import 'package:pro1/models/sponsor_add.dart';
import 'package:pro1/models/subscription.dart';
import 'package:pro1/models/user.dart';
import 'package:stacked/stacked.dart';

class LoginedUser with ReactiveServiceMixin {
  RxValue<CurrentUser> _currentUser = RxValue<CurrentUser>();
  List<SelfProduct> _selfProductList;
  Subscription _subscription;
  bool isBusy = false;
  List<SponsorAdd> _sponsorAdds;

  setBusy(bool value) {
    isBusy = value;
    notifyListeners();
  }

///////////////////////////////////////////
///////// SponsorAdds section ///////////
/////////////////////////////////////////

  List<SponsorAdd> get sponsorAdds => _sponsorAdds;

  set sponsorAdds(List<SponsorAdd> list) {
    _sponsorAdds = list;
    notifyListeners();
  }

  ///////////////////////////////////////////
///////// Subscription Actions ///////////
/////////////////////////////////////////

  get subscription => _subscription;

  set subscription(Subscription sub) {
    _subscription = sub;
    notifyListeners();
  }

///////////////////////////////////////////
///////// Product List Actions ///////////
/////////////////////////////////////////

  get selfProductList => _selfProductList;

  set currentUser(CurrentUser user) {
    _currentUser.value = user;
  }

  set selfProductList(List<SelfProduct> list) {
    _selfProductList = list;
    notifyListeners();
  }

  setSingleSelfProductList({SelfProduct product, String productId}) {
    for (int i = 0; i < selfProductList.length; i++) {
      if (selfProductList[i].productId == productId) {
        print(selfProductList[i].productName + " updated");
        _selfProductList[i] = product;
      }
      notifyListeners();
    }
    notifyListeners();
  }

  addSingleSelfProduct(product) {
    _selfProductList.add(product);
    notifyListeners();
  }

  deleteAllSelfProducts() {
    _selfProductList.clear();
  }

  deleteSingleProduct({String productId}) {
    // _selfProductList.removeAt(index);
    for (int i = 0; i < selfProductList.length; i++) {
      if (selfProductList[i].productId == productId) {
        print(selfProductList[i].productName + " deleted");
        _selfProductList.removeAt(i);
      }
      notifyListeners();
    }
  }

///////////////////////////////////////////
///////// Current USer Actions ///////////
/////////////////////////////////////////

  CurrentUser get currentUser => _currentUser.value;

  setProfileImage({String imageName, String url}) {
    _currentUser.value.imageFileName = imageName;
    _currentUser.value.imageUrl = url;
    notifyListeners();
  }

  deleteCurrentUserData() {
    currentUser = null;
    _selfProductList = null;
    _subscription = null;
  }

  LoginedUser() {
    listenToReactiveValues([_currentUser.value]);
  }
}
