import 'dart:async';
import 'package:money_grower/models/transaction_model.dart';
import 'package:money_grower/resources/transaction_provider.dart';
import 'package:money_grower/resources/user_provider.dart';
import '../models/user_model.dart';

class Repository {
  final userProvider = UserProvider();
  final transactionProvider = TransactionProvider();

  Future getUserByUsername(String username) =>
      userProvider.getUserByUsername(username);

  Future insertUser(UserModel data) => userProvider.insertUser(data);

  Future updateUser(UserModel data, String id) =>
      userProvider.updateUser(data, id);

  Future getTransactionSummaryOfMonth(DateTime date, String username) =>
      transactionProvider.getTransactionSummaryOfMonth(date, username);

  Future getLoanList(String username) => transactionProvider.getLoanList(username);

  Future insertTransaction(TransactionModel transaction) =>
      transactionProvider.insertTransaction(transaction);

  Future deleteTransaction(String id) =>
      transactionProvider.deleteTransaction(id);

  updateTransaction(TransactionModel transaction) =>
      transactionProvider.updateTransaction(transaction);
}
