import 'package:loginapp/models/transaction_model.dart';
import 'package:loginapp/resources/repository.dart';


class TransactionBloc {
  final repository = Repository();

  Future getTransactionSummaryOfMonth(DateTime date, String username) =>
    repository.getTransactionSummaryOfMonth(date, username);

  Future insertTransaction(TransactionModel transaction) =>
    repository.insertTransaction(transaction);
}