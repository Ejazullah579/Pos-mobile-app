import 'package:pro1/app/locator.dart';
import 'package:pro1/models/transaction.dart' as transaction;
import 'package:pro1/services/logined_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

const String DB_NAME = 'shopify_database.sqlite';

const String DailyTableName = 'daily_history';
const String WeeklyTableName = 'weekly_history';
const String MonthlyTableName = 'monthly_history';

class LocalDatabaseService {
  final _migrationService = locator<DatabaseMigrationService>();
  final _loogedInUser = locator<LoginedUser>();

  Database _database;
  Future initialise() async {
    _database = await openDatabase(DB_NAME, version: 1);

    await _migrationService.runMigration(
      _database,
      migrationFiles: [
        '1_create_schema.sql',
      ],
      verbose: true,
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ////////////////////////////// Daily Transaction ////////////////////////////
  //////////////////////////////////// part //////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////

  /// will only get the last 10 transactions saved in daily_history table
  /// that are being displayed in Home view.

  Future<List<transaction.Transaction>> getLastTenTransactions() async {
    // Get all the data from the DailyTableName
    List<Map> transactionResults = await _database.query(DailyTableName,
        where: "user_id=?", whereArgs: [_loogedInUser.currentUser.id]);
    if (transactionResults.length > 10) {
      return transactionResults
          .getRange(transactionResults.length - 10, transactionResults.length)
          .map((trans) => transaction.Transaction.fromJson(trans))
          .toList();
    }
    // Map data to a Transaction object
    else
      return transactionResults
          .map((trans) => transaction.Transaction.fromJson(trans))
          .toList();
  }

  /// will get all the daily transactions form daily_history Table
  /// will be used in calculating daily selling and will be saved as
  /// an entry in the weekly_history Table.

  Future<List<transaction.Transaction>> getAllDailyTransactions() async {
    // Get all the data from the DailyTableName
    List<Map> transactionResults = await _database.query(DailyTableName,
        where: "user_id=?", whereArgs: [_loogedInUser.currentUser.id]);
    // Map data to a Transaction object
    return transactionResults
        .map((trans) => transaction.Transaction.fromJson(trans))
        .toList();
  }

  // for filtering transactions based on the date range passed
  Future<List<transaction.Transaction>> getAllDailyTransactionsFromRanage(
      {String from, String to}) async {
    // Get all the data from the DailyTableName
    List<Map> transactionResults = await _database.query(DailyTableName,
        where: "user_id=?", whereArgs: [_loogedInUser.currentUser.id]);
    // Map data to a Transaction object
    List<transaction.Transaction> list = transactionResults
        .map((trans) => transaction.Transaction.fromJson(trans))
        .toList();

    List<transaction.Transaction> endList = [];

    for (int i = 0; i < list.length; i++) {
      if (from != null && to != null) {
        if (list[i].date.isAfter(DateTime.tryParse(from)) &&
            (list[i].date.isBefore(DateTime.tryParse(to)) ||
                list[i].date.toString().contains(to))) {
          endList.add(list[i]);
        }
      } else if (from != null && to == null) {
        if (list[i].date.isAfter(DateTime.tryParse(from)) ||
            list[i].date.toIso8601String().contains(from)) {
          endList.add(list[i]);
        }
      } else if (from == null && to != null) {
        if (list[i].date.isBefore(DateTime.tryParse(to)) ||
            list[i].date.toString().contains(to)) {
          endList.add(list[i]);
        }
      } else {
        endList.add(list[i]);
      }
    }
    return endList;
  }

  /// 1 entry will be created everytime, user presses the print button in
  /// getItem View after generation recipt, in daily_history Table

  Future addDailyTransaction(
      {DateTime date, double amount, int totalProductsSoled}) async {
    try {
      await _database.insert(
        DailyTableName,
        transaction.Transaction(
                date: date,
                amount: amount,
                totalProductsSoled: totalProductsSoled,
                userId: _loogedInUser.currentUser.id)
            .toJson(),
      );
    } catch (e) {
      print('Could not insert the daily transaction: $e');
    }
  }

  /// after capturing all day transactions a sum will be calculated and an entry
  ///  for weekly table will be created and daily transaction history will be reset

  Future deleteDailyHistory() async {
    try {
      await _database.delete(DailyTableName);
    } catch (e) {
      print("Error: $e");
    }
  }

  // Future updateCompleteForTodo({int id, bool complete}) async {
  //   try {
  //     await _database.update(
  //       TodoDailyTableName,
  //       // We only pass in the data we want to update.
  //       // The field used here already has to exist in the schema
  //       {'complete': complete ? 1 : 0},
  //       where: 'id = ?',
  //       whereArgs: [id],
  //     );
  //   } catch (e) {
  //     print('Could not update the todo with id:$id. $e');
  //   }
  // }

  //////////////////////////////////////////////////////////////////////////////
  ///////////////////////////// Weekly Transaction ////////////////////////////
  /////////////////////////////////// part ///////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////

  /// 1 entry of daily amount will be created

  Future addWeeklyTransaction() async {
    try {
      List<transaction.Transaction> list = await getAllDailyTransactions();
      double totalAmount = 0;
      int totalProductsSoled = 0;
      list.forEach((element) {
        if (element.date.toString().substring(0, 10) ==
            DateTime.now()
                .add(Duration(days: -1))
                .toString()
                .substring(0, 10)) {
          {
            totalAmount += element.amount;
            totalProductsSoled += element.totalProductsSoled;
          }
        }
      });
      await _database.insert(
        WeeklyTableName,
        transaction.Transaction(
                shouldAddTime: false,
                date: DateTime.now().add(Duration(days: -1)),
                amount: totalAmount,
                totalProductsSoled: totalProductsSoled,
                userId: list.first.userId)
            .toJson(),
      );
    } catch (e) {
      print('Could not insert the weekly transaction: $e');
    }
  }

  Future<List<transaction.Transaction>> getAllWeeklyTransactions() async {
    // Get all the data from the WeeklyTableName
    List<Map> transactionResults = await _database.query(WeeklyTableName,
        where: "user_id=?", whereArgs: [_loogedInUser.currentUser.id]);
    // Map data to a Transaction object
    return transactionResults.map((trans) {
      return transaction.Transaction.fromJson(trans);
    }).toList();
  }

  Future<transaction.Transaction> getLastWeeklyTransactions() async {
    // Get last item from the WeeklyTableName
    try {
      DateTime now = DateTime.now().add(Duration(days: -1));
      List<Map> transactionResults = await _database
          .query(WeeklyTableName, where: "user_id=? and date=?", whereArgs: [
        _loogedInUser.currentUser.id,
        now.toString().substring(0, 10),
      ]);
      // print(transactionResults.first);
      // Map data to a Transaction object
      return transaction.Transaction.fromJson(transactionResults.first);
    } catch (e) {
      print('Could not insert the weekly transaction: $e');
    }
  }
}
