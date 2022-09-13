import 'package:pro1/models/achievments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrencesService {
  /// to check in shared prefrences if user is using the app for first time
  Future<bool> isFirstTime() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isFirstTime = sp.getBool("Visited") ?? true;
    return isFirstTime;
  }

  setIsFirstTime() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool("Visited", false);
  }

  /// get discount info set in setting view : Type : shared Prefrences
  Future<List> getDiscountInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    double value = sp.getDouble("discount_value") ?? 0;
    double percent = sp.getDouble("discount_percent") ?? 0;
    bool applyDiscount = sp.getBool("apply_discount") ?? true;
    bool showHideNavbarButton = sp.getBool("showHideNavbarButton") ?? false;
    List list = [value, percent, applyDiscount, showHideNavbarButton];
    return list;
  }

  //// isFirstTimeInHome
  getIsFirstTimeInHome() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = sp.getBool("isFirstTimeInHome") ?? true;
    return result;
  }

  setIsFirstTimeInHome({bool value}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool("isFirstTimeInHome", value);
  }

  //// isFirstTimeInScannerView
  getIsFirstTimeInScannerView() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = sp.getBool("isFirstTimeInScannerView") ?? true;
    return result;
  }

  setIsFirstTimeInScannerView({bool value}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool("isFirstTimeInScannerView", value);
  }

  Future<bool> getshouldGenerateQrImage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = sp.getBool("shouldGenerateQrImage") ?? true;
    return result;
  }

  setshouldGenerateQrImage(bool value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await sp.setBool("shouldGenerateQrImage", value);
    return result;
  }

  ///// Getting and Setting Achievments

  Future<Achievments> getAchievments() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return Achievments(
        totalSales: sp.getInt("totalSales") ?? 0,
        totalDaysAppUsed: sp.getInt("totalDaysAppUsed") ?? 0,
        totalProductsSoled: sp.getInt("totalProductsSoled") ?? 0);
  }

  setAchievments(
      {int totalSales, int totalDaysAppUsed, int totalProductsSoled}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (totalSales != null) await sp.setInt("totalSales", totalSales);
    if (totalDaysAppUsed != null)
      await sp.setInt("totalDaysAppUsed", totalSales);
    if (totalProductsSoled != null)
      await sp.setInt("totalProductsSoled", totalProductsSoled);
  }
}
