import 'package:money_grower/models/transaction_model.dart';

class TransactionSummary {
  int totalIncome;
  int totalExpense;
  int totalTransaction;
  List incomeList;
  List expenseList;
  DateTime date;

  static final TransactionSummary _instance = TransactionSummary._internal();
  TransactionSummary._internal();

  factory TransactionSummary() {
    return _instance;
  }

  fromMap(Map snapshot) {
    _instance.totalIncome = snapshot['total-income'];
    _instance.totalExpense = snapshot['total-expense'];
    _instance.totalTransaction = snapshot['total-transaction'];
    _instance.incomeList = snapshot['income-list'];
    _instance.expenseList = snapshot['expense-list'];
    _instance.date = snapshot['date'];
  }
}