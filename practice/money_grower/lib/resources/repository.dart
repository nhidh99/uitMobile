import 'dart:async';
import 'package:money_grower/models/budget_model.dart';
import 'package:money_grower/models/transaction_model.dart';
import 'package:money_grower/resources/budget_provider.dart';
import 'package:money_grower/resources/transaction_provider.dart';
import 'package:money_grower/resources/user_provider.dart';
import '../models/user_model.dart';

class Repository {
  final userProvider = UserProvider();
  final transactionProvider = TransactionProvider();
  final budgetProvider = BudgetProvider();

  Future getUserByUsername(String username) =>
      userProvider.getUserByUsername(username);

  Future insertUser(UserModel data) => userProvider.insertUser(data);

  Future updateUser(UserModel data, String id) =>
      userProvider.updateUser(data, id);

  Future getTransactionSummaryOfMonth(DateTime date, String username) =>
      transactionProvider.getTransactionSummaryOfMonth(date, username);

  Future getPriceOfTransactionTypeInTime(
          String name, DateTime beginDate, DateTime endDate, String username) =>
      transactionProvider.getPriceOfTransactionTypeInTime(
          name, beginDate, endDate, username);

  Future getLoanDebtList(String username) =>
      transactionProvider.getLoanDebtList(username);

  Future insertTransaction(TransactionModel transaction) =>
      transactionProvider.insertTransaction(transaction);

  Future deleteTransaction(String id) =>
      transactionProvider.deleteTransaction(id);

  Future updateTransaction(TransactionModel transaction) =>
      transactionProvider.updateTransaction(transaction);

  Future getBudgetsByUsername(String username) =>
      budgetProvider.getBudgetsByUsername(username);

  Future insertBudget(BudgetModel budget) => budgetProvider.insertBudget(budget);

  Future deleteBudget(String id) => budgetProvider.deleteBudget(id);
}
