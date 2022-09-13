import 'package:ntp/ntp.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/enums/bottom_sheet_type.dart';
import 'package:pro1/models/sponsor_add.dart';
import 'package:pro1/models/subscription.dart';
import 'package:pro1/models/transaction.dart';
import 'package:pro1/models/user.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/services/remote_config_service.dart';
import 'package:pro1/services/firestore_service.dart';
import 'package:pro1/services/local_database_service.dart';
import 'package:pro1/services/logined_user.dart';
import 'package:pro1/services/shared_prefrences_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends ReactiveViewModel {
  final _currentUser = locator<LoginedUser>();
  final globalService = locator<GlobalService>();
  final _sharedPrefrencesService = locator<SharedPrefrencesService>();
  final _firestoreService = locator<FirestoreService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _localDatabaseService = locator<LocalDatabaseService>();
  final _remoteConfigService = locator<RemoteConfigService>();

  CurrentUser get currentUser => _currentUser.currentUser;
  get subscription => _currentUser.subscription;
  bool get isCurrentUserBusy => _currentUser.isBusy;
  List<SponsorAdd> get sponsorAddList => _currentUser.sponsorAdds;
  bool get freeServices => _remoteConfigService.freeServices;
  bool showWalkThrough = false;
  List<Transaction> lastTenTransactionList = [];

  ///// For calculating subscription info
  bool isBusyGettingTime = false;
  setisBusyGettingTime(bool val) {
    isBusyGettingTime = val;
    notifyListeners();
  }

  DateTime currentTime;
  Duration _daysLeft;
  get daysLeft => _daysLeft;
  bool isSubscriptionExpired;

  bool _isBusyGettingSponsorAdds = false;
  bool get isBusyGettingSponsorAdds => _isBusyGettingSponsorAdds;
  set isBusyGettingSponsorAdds(value) {
    _isBusyGettingSponsorAdds = value;
    notifyListeners();
  }

  Future handleReadyLogic() async {
    setBusy(true);
    await getSubscriptionData();
    await Future.delayed(Duration(milliseconds: 800));
    var result = await _localDatabaseService.getLastTenTransactions();
    if (result is List<Transaction>) lastTenTransactionList = result;
    await Future.delayed(Duration(milliseconds: 1500));
    showWalkThrough = await _sharedPrefrencesService.getIsFirstTimeInHome();
    // await isFirstTimeInHome();
    setBusy(false);
  }

  Future refresh() async {
    var result = await _localDatabaseService.getLastTenTransactions();
    if (result is List<Transaction>) lastTenTransactionList = result;
    await getSubscriptionData(shouldGetSubscription: true);
    // await isFirstTimeInHome();
    setBusy(false);
  }

  Stream<List<Transaction>> getTransactionList() async* {
    var result = await _localDatabaseService.getLastTenTransactions();
    yield result;
  }

  setWalkThrough() {
    _sharedPrefrencesService.setIsFirstTimeInHome(value: false);
  }

  showTransactionHistoryError() async {
    await _bottomSheetService.showBottomSheet(
        title: "Error retrieving Transaction history");
  }

  Future<List<Transaction>> showAllDailyTransactions() async {
    return await _localDatabaseService.getAllDailyTransactions();
  }

  Future<DateTime> getCurrentTime() async {
    var result;
    try {
      await Future.delayed(Duration(seconds: 10), () async {
        var getTime = await NTP.now();
        if (getTime is DateTime) currentTime = getTime;
        _daysLeft = currentTime
            .difference(DateTime.tryParse(_currentUser.subscription.endDate));
        isSubscriptionExpired = currentTime.isBefore(
                DateTime.tryParse(_currentUser.subscription.endDate)) ??
            true;
        result = currentTime;
      });
      notifyListeners();
    } catch (e) {
      print("samosa" + e.toString());
    }

    return result;
  }

  Future getSubscriptionData({bool shouldGetSubscription = false}) async {
    setisBusyGettingTime(true);
    if (shouldGetSubscription) {
      var result = await _firestoreService.getSubscription(
          userId: _currentUser.currentUser.id);
      if (result is Subscription) _currentUser.subscription = result;
    }
    currentTime = await NTP.now();
    _daysLeft = currentTime
        .difference(DateTime.tryParse(_currentUser.subscription.endDate));
    isSubscriptionExpired = currentTime
            .isBefore(DateTime.tryParse(_currentUser.subscription.endDate)) ??
        true;
    setisBusyGettingTime(false);
  }

  // isFirstTimeInHome() async {
  //   bool isFirstTimeInHome = await _sharedPrefrencesService
  //       .getIsFirstTimeInHome(userId: currentUser.id);
  //   if (isFirstTimeInHome) {
  //     await Future.delayed(Duration(milliseconds: 600));
  //     await _bottomSheetService.showBottomSheet(
  //         title: "Congratulaions!",
  //         description:
  //             "You have been given 7 days free trial of our pro version. Thank you for trusting us and we will keep providing best and reliable services to our valuable costumers.");
  //     _sharedPrefrencesService.setIsFirstTimeInHome(
  //         value: false, userId: currentUser.id);
  //   }
  //   // _sharedPrefrencesService.setIsFirstTimeInHome(true);
  // }

  // Future getAllAdds() async {
  //   // var now = DateTime.now();
  //   // var result1 = await _firestoreService.addSponsorAdd(SponsorAdd(
  //   //     title: "samosa",
  //   //     type: "product",
  //   //     videoUrl: "n6Awpg1MO6M",
  //   //     expiryDate:
  //   //         DateTime(now.year, now.month, now.day + 7, 23, 59, 59).toString()));
  //   isBusyGettingSponsorAdds = true;
  //   // await Future.delayed(Duration(seconds: 3));
  //   var result2 = await _firestoreService.gettAllSponsorAdds();
  //   if (result2 is String) {
  //     isBusyGettingSponsorAdds = false;
  //     await _bottomSheetService.showBottomSheet(
  //         title: "Error retrieving Transaction history",
  //         description: result2.toString());
  //   } else {
  //     // print(result2.length);
  //     sponsorAddList = result2;
  //     isBusyGettingSponsorAdds = false;
  //     notifyListeners();
  //   }
  // }

  showPurchaseSubscriptionBottomSheet() async {
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.subscription,
    );
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_currentUser];
}
