import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/app/router.gr.dart';
import 'package:pro1/models/achievments.dart';
import 'package:pro1/models/user.dart';
import 'package:pro1/services/authetication_service.dart';
import 'package:pro1/services/connectivity_service.dart';
import 'package:pro1/services/firestore_service.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/services/local_database_service.dart';
import 'package:pro1/services/logined_user.dart';
import 'package:pro1/services/remote_config_service.dart';
import 'package:pro1/services/shared_prefrences_service.dart';
import 'package:pro1/ui/views/drawer/drawer_view.dart';
import 'package:pro1/ui/views/greetings/main_greeting_view.dart';
import 'package:pro1/ui/views/home/full_bottom_navbar.dart';
import 'package:pro1/ui/views/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends ReactiveViewModel {
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _connectivityService = locator<ConnectivityService>();
  final _authenticationService = locator<AuthenticationService>();
  final _firestoreService = locator<FirestoreService>();
  final _localDatabaseService = locator<LocalDatabaseService>();
  final _remoteConfigService = locator<RemoteConfigService>();
  final _globalService = locator<GlobalService>();
  final _sharedPrefrences = locator<SharedPrefrencesService>();
  GlobalService get globalService => _globalService;
  final _currentUser = locator<LoginedUser>();
  CurrentUser get currentUser => _currentUser.currentUser;
  Achievments get achievments => _currentUser.currentUser.achievments;

  //////// For showing user what system is doing in background

  String workingInfo = "";
  setWorkingInfo({String value, bool shouldNotDelay}) async {
    if (shouldNotDelay == null)
      await Future.delayed(Duration(milliseconds: 100));
    workingInfo = value;
    notifyListeners();
  }

  ///// Main working of the start up view

  Future handleStartUpLogic(context) async {
    setBusy(true);
    await checkPermissions();
    //// checking connection status
    await setWorkingInfo(value: "checking internet connection");
    bool result = await _connectivityService.checkConnectionStatus();
    if (result != null) {
      if (result) {
        return _navigationService.pushNamedAndRemoveUntil(Routes.startupView);
      } else
        return SystemNavigator.pop();
    }
    //// seting up remote config
    await _remoteConfigService.initialise();

    /// For displaying slides if user came for first time
    var isfirstTime = await _sharedPrefrences.isFirstTime();

    /// for setting discount info from shared prefrences
    await setWorkingInfo(value: "getting user settings");
    List list = await _sharedPrefrences.getDiscountInfo();
    _globalService.discountValue = list[0];
    _globalService.discountPercentage = list[1];
    _globalService.applyDiscount = list[2];
    _globalService.showHideNavbarButton = list[3];
    _globalService.shouldGenerateQrImage =
        await _sharedPrefrences.getshouldGenerateQrImage();

    /// Type : Sql Database
    await setWorkingInfo(value: "setting up local database");
    await _localDatabaseService.initialise();

    /// checking firebase records if user has loged in or not
    await setWorkingInfo(value: "getting user info");
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
    if (hasLoggedInUser) updateUserInfo();
    await setWorkingInfo(value: "Thank you for waiting", shouldNotDelay: true);

    setBusy(false);
    await Future.delayed(Duration(seconds: 1));

    // SharedPreferences sp = await SharedPreferences.getInstance();
    // await sp.setString("lastDate", DateTime.now().toIso8601String());

    /// For Greeting page
    if (isfirstTime) {
      setupUpdateTime();
      _navigationService.replaceWithTransition(
        MainGreetingsPage(),
        duration: Duration(milliseconds: 1000),
        transition: NavigationTransition.RightToLeft,
      );
    } else if (hasLoggedInUser) {
      _navigationService.replaceWithTransition(
        DrawerView(),
        duration: Duration(milliseconds: 1000),
        transition: NavigationTransition.RightToLeft,
      );
    } else {
      NavigationService().replaceWithTransition(
        LoginView(),
        duration: Duration(milliseconds: 1000),
        transition: NavigationTransition.RightToLeft,
      );
    }
  }

  /// after capturing all day transactions, the next day the user opens an app ,
  /// a sum will be calculated and an entry for weekly table will be created
  /// and daily transaction history will be reset

  Future<void> updateUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    DateTime currentDate = await Future.value(NTP.now())
        .timeout(Duration(seconds: 10), onTimeout: () => DateTime.now());
    String lastDate = sp.getString("lastDate");
    // print("last date " + lastDate);
    if (currentDate.isAfter(DateTime.tryParse(lastDate)) &&
        currentDate != null) {
      await _localDatabaseService.addWeeklyTransaction();
      print("User Info Updated");
      ///// Setting achievments first time everyday users logins
      var yesterdayAchievments = await _sharedPrefrences.getAchievments();
      Achievments updatedAchievments = Achievments(
          totalSales: yesterdayAchievments.totalSales + achievments.totalSales,
          totalDaysAppUsed: achievments.totalDaysAppUsed + 1,
          totalProductsSoled: yesterdayAchievments.totalProductsSoled +
              achievments.totalProductsSoled);
      _currentUser.currentUser.achievments = updatedAchievments;
      await _firestoreService.updateUserAchievments(_currentUser.currentUser);
      await _firestoreService.addDailyTransactionHistory();
      _sharedPrefrences.setAchievments(totalSales: 0, totalProductsSoled: 0);
      await sp.setString(
          "lastDate",
          DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59,
                  59)
              .toIso8601String());
    } else {}
  }

  Future<void> checkPermissions() async {
    var photoPermissionStatus = await Permission.photos.request();
    var cameraPermissionStatus = await Permission.camera.request();
    var storagePermissionStatus = await Permission.storage.request();
    if (photoPermissionStatus.isDenied ||
        photoPermissionStatus.isPermanentlyDenied ||
        photoPermissionStatus.isUndetermined ||
        photoPermissionStatus.isRestricted ||
        cameraPermissionStatus.isDenied ||
        cameraPermissionStatus.isPermanentlyDenied ||
        cameraPermissionStatus.isUndetermined ||
        cameraPermissionStatus.isRestricted ||
        storagePermissionStatus.isDenied ||
        storagePermissionStatus.isPermanentlyDenied ||
        storagePermissionStatus.isUndetermined ||
        storagePermissionStatus.isRestricted) {
      await _bottomSheetService
          .showBottomSheet(
            title: "Permission Denied.",
            description:
                "Sorry you must allow these Permissions inorder to use the app",
          )
          .then((value) => SystemNavigator.pop());
    }
  }

  Future<void> setupUpdateTime() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString("lastDate", DateTime.now().toIso8601String());
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_currentUser];
}
