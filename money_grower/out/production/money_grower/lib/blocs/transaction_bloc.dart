import 'package:money_grower/models/transaction_model.dart';
import 'package:money_grower/resources/repository.dart';

class TransactionBloc {
  final repository = Repository();

  Future getPriceOfTransactionTypeInTime(
          String name, DateTime beginDate, DateTime endDate, String username) =>
      repository.getPriceOfTransactionTypeInTime(
          name, beginDate, endDate, username);

  Future getTransactionSummaryOfMonth(DateTime date, String username) =>
      repository.getTransactionSummaryOfMonth(date, username);

  Future getLoanDebtList(String username) =>
      repository.getLoanDebtList(username);

  Future insertTransaction(TransactionModel transaction) =>
      repository.insertTransaction(transaction);

  Future updateTransaction(TransactionModel transaction) =>
      repository.updateTransaction(transaction);

  Future deleteTransaction(TransactionModel transaction) =>
    repository.deleteTransaction(transaction);
}
