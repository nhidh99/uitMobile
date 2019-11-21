import 'package:money_grower/resources/repository.dart';

class TransactionBloc {
  final repository = Repository();

  Future getTransactionSummaryOfMonth(DateTime date, String username) =>
    repository.getTransactionSummaryOfMonth(date, username);
}