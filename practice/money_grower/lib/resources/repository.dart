import 'dart:async';
import 'package:loginapp/models/transaction_model.dart';
import 'package:loginapp/resources/transaction_provider.dart';
import 'package:loginapp/resources/user_provider.dart';

import '../models/user_model.dart';

class Repository {
  final userProvider = UserProvider();
  final transactionProvider = TransactionProvider();

  Future getUserByUsername(String username) =>
      userProvider.getUserByUsername(username);

  Future insertUser(UserModel data) =>
    userProvider.insertUser(data);

  Future updateUser(UserModel data, String id) =>
      userProvider.updateUser(data, id);

  Future getTransactionSummaryOfMonth(DateTime date, String username) =>
      transactionProvider.getTransactionSummaryOfMonth(date, username);

  insertTransaction(TransactionModel transaction) =>
    transactionProvider.insertTransaction(transaction);

  Future isUserExist(String uid) => userProvider.isUserExist(uid);
}
