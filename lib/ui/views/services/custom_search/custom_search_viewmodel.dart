import 'package:flutter/material.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/models/transaction.dart';
import 'package:pro1/services/local_database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomSearchViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _localDatabaseService = locator<LocalDatabaseService>();

  ////// Custom Search Section
  List<Transaction> _transactionList;
  List<Transaction> get transactionList => _transactionList;
  List<int> dateHeadingsIndexes = [];
  String fromText;
  String toText;
  String date; ////for listing dates while showing the list data

  Future<List<Transaction>> showAllDailyTransactions() async {
    setBusy(true);
    if (fromText != null && toText != null) {
      if (DateTime.tryParse(toText).isBefore(DateTime.tryParse(fromText))) {
        setBusy(false);
        await _bottomSheetService.showBottomSheet(
            title: "Wrong Formate",
            description: "Please provide a valid date range");
        return null;
      }
    }
    await Future.delayed(Duration(seconds: 1));
    _transactionList = await _localDatabaseService
            .getAllDailyTransactionsFromRanage(from: fromText, to: toText) ??
        [];
    findDateIndexes(transactionList: _transactionList);
    setBusy(false);
    notifyListeners();
  }

/////////// for custom view
  findDateIndexes({List<Transaction> transactionList}) {
    dateHeadingsIndexes = [];
    date = null;
    for (int i = 0; i < transactionList.length; i++) {
      if (date == null) {
        date = transactionList[i].date.toIso8601String().substring(0, 10);
        dateHeadingsIndexes.add(i);
      } else if (!transactionList[i].date.toIso8601String().contains(date)) {
        date = transactionList[i].date.toIso8601String().substring(0, 10);
        dateHeadingsIndexes.add(i);
      }
    }
  }

/////////// for custom view
  selectDate({context, String field}) async {
    DateTime date = DateTime(1900);
    date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      if (field == "from")
        fromText = date.toIso8601String().substring(0, 10);
      else if (field == "to") toText = date.toIso8601String().substring(0, 10);
    }
    notifyListeners();
  }
}
