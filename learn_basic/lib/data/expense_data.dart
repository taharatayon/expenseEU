import 'package:flutter/material.dart';
import 'package:learn_basic/data/hive_database.dart';
import 'package:learn_basic/datetime/date_time_helper.dart';
import 'package:learn_basic/models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  //list of all expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  //prepare data to display
  final db = HiveDataBase();
  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  //add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //delete expense
  void delteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get weekday
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  //get the date for the start of the week
  DateTime startofWeekDate() {
    DateTime? startofWeek;

    //get todays date
    DateTime today = DateTime.now();

    //go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startofWeek = today.subtract(Duration(days: i));
      }
    }
    return startofWeek!;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummmary = {
      //date (yyyymmdd):amountTotalForDay
    };
    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      if (dailyExpenseSummmary.containsKey(date)) {
        double currentAmount = dailyExpenseSummmary[date]!;
        currentAmount += amount;
        dailyExpenseSummmary[date] = currentAmount;
      } else {
        dailyExpenseSummmary.addAll({date: amount});
      }
    }
    return dailyExpenseSummmary;
  }
}
