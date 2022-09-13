import 'package:pro1/app/locator.dart';
import 'package:pro1/models/achievments.dart';
import 'package:pro1/models/transaction.dart';
import 'package:pro1/services/firestore_service.dart';
import 'package:pro1/services/local_database_service.dart';
import 'package:pro1/services/logined_user.dart';
import 'package:stacked/stacked.dart';

class SalesReportModel extends BaseViewModel {
  final _currentUser = locator<LoginedUser>();
  final _firestoreService = locator<FirestoreService>();
  final _localDatabaseService = locator<LocalDatabaseService>();

  bool get isCurrentUserBusy => _currentUser.isBusy;
  Achievments get achievments => _currentUser.currentUser.achievments;
  List<Transaction> weeklyTransactionList = [];
  List<Transaction> dailyTransactionList = [];

  Future<void> getListsData() async {
    setBusy(true);
    var weeklyResult = await _firestoreService.getAllDailyTransactionHistory();
    if (weeklyResult is List<Transaction>) weeklyTransactionList = weeklyResult;
    var dailyResult = await _localDatabaseService.getAllDailyTransactions();
    if (dailyResult is List<Transaction>) dailyTransactionList = dailyResult;

    setBusy(false);
  }

  getAchievment({type, double number}) {
    int num;
    if (type == "totalSales")
      num = achievments.totalSales;
    else if (type == "totalProductsSoled")
      num = achievments.totalProductsSoled;
    else if (type == "totalDaysAppUsed") num = achievments.totalDaysAppUsed;
    if (number != null) num = number.toInt();
    if (num > 999 && num < 1000000) {
      return (num / 1000).toStringAsFixed(2) +
          'K'; // convert to K for number from > 1000 < 1 million
    } else if (num > 1000000) {
      return (num / 1000000).toStringAsFixed(1) +
          'M'; // convert to M for number from > 1 million
    } else if (num < 900) {
      return num.toString(); // if value < 1000, nothing to do
    }
  }
}
