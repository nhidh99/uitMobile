
class TransactionSummary {
  int totalIncome;
  int totalExpense;
  int totalTransaction;
  List transactionList;
  DateTime date = DateTime.now();

  static final TransactionSummary _instance = TransactionSummary._internal();
  TransactionSummary._internal();

  factory TransactionSummary() {
    return _instance;
  }

  fromMap(Map snapshot) {
    _instance.totalIncome = snapshot['total-income'];
    _instance.totalExpense = snapshot['total-expense'];
    _instance.totalTransaction = snapshot['total-transaction'];
    _instance.transactionList = snapshot['transaction-list'];
    _instance.date = snapshot['date'];
  }
}