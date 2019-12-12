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

  Future updateUser(UserModel data) => userProvider.updateUser(data);

  Future getTransactionById(String id) =>
      transactionProvider.getTransactionById(id);

  Future getTransactionSummaryOfMonth(DateTime date, String username) =>
      transactionProvider.getTransactionSummaryOfMonth(date, username);

  Future getPriceOfTransactionTypeInTime(
          String name, DateTime beginDate, DateTime endDate, String username) =>
      transactionProvider.getPriceOfTransactionTypeInTime(
          name, beginDate, endDate, username);

  Future getLoanDebtList(String username) =>
      transactionProvider.getLoanDebtList(username);

  Future insertTransaction(TransactionModel transaction) async {
    transactionProvider.insertTransaction(transaction);

    // Update user income
    final user = UserModel();
    user.income += transaction.price;
    await userProvider.updateUser(user);

    // Update match budget
    final budget = await budgetProvider.getMatchBudgetByTransaction(
        transaction, UserModel().username);

    if (budget != null) {
      budget.totalUsed -= transaction.price;
      budgetProvider.updateBudget(budget);
    }
  }

  Future deleteTransaction(TransactionModel transaction) async {
    await transactionProvider.deleteTransaction(transaction.id);
    final budget = await budgetProvider.getMatchBudgetByTransaction(
        transaction, UserModel().username);

    // Update user income
    final user = UserModel();
    user.income -= transaction.price;
    await userProvider.updateUser(user);

    // Update match budget
    if (budget != null) {
      budget.totalUsed += transaction.price;
      budgetProvider.updateBudget(budget);
    }
  }

  Future updateTransaction(TransactionModel transaction) async {
    final oldTransaction =
        await transactionProvider.getTransactionById(transaction.id);
    deleteTransaction(oldTransaction);
    insertTransaction(transaction);
  }

  Future getBudgetsByUsername(String username) =>
      budgetProvider.getBudgetsByUsername(username);

  Future insertBudget(BudgetModel budget) =>
      budgetProvider.insertBudget(budget);

  Future deleteBudget(String id) => budgetProvider.deleteBudget(id);

  Future updateBudget(BudgetModel budget) =>
      budgetProvider.updateBudget(budget);

  Future getMatchBudgetByTransaction(
          TransactionModel transaction, String username) =>
      budgetProvider.getMatchBudgetByTransaction(transaction, username);
}
