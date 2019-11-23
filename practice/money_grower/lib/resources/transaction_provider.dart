import 'dart:async';
import 'package:money_grower/helper/doc_helper.dart';
import 'package:money_grower/models/transaction_model.dart';

class TransactionProvider {
  final doc = DocHelper('transactions');

  Future getTransactionSummaryOfMonth(DateTime date, String username) async {
    var totalIncome = 0;
    var totalExpense = 0;
    var transactionList = [];

    final response = await doc.ref
        .where('username', isEqualTo: username)
        .where('date-year', isEqualTo: date.year)
        .where('date-month', isEqualTo: date.month)
        .getDocuments();

    response.documents.forEach((doc) {
      transactionList.add(TransactionModel.fromMap(doc.data, doc.documentID));
      final price = doc.data['price'];
      if (price > 0) {
        totalIncome += price;
      }
      else {
        totalExpense -= price;
      }
    });

    return {
      'total-income': totalIncome,
      'total-expense': totalExpense,
      'total-transaction': totalIncome - totalExpense,
      'transaction-list': transactionList,
      'date': date
    };
  }
}