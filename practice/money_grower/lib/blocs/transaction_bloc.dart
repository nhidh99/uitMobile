import 'package:money_grower/models/transaction_model.dart';
import 'package:money_grower/resources/repository.dart';

class TransactionBloc {
  final repository = Repository();

  Future getTransactionSummaryOfMonth(DateTime date, String username) =>
      repository.getTransactionSummaryOfMonth(date, username);

  Future insertTransaction(TransactionModel transaction) =>
      repository.insertTransaction(transaction);

  Future updateTransaction(TransactionModel transaction) =>
    repository.updateTransaction(transaction);

  Future deleteTransaction(String id) => repository.deleteTransaction(id);
}
