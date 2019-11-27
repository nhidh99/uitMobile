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
      } else {
        totalExpense -= price;
      }
    });

    transactionList.sort((a, b) => a.name.compareTo(b.name));

    return {
      'total-income': totalIncome,
      'total-expense': totalExpense,
      'total-transaction': totalIncome - totalExpense,
      'transaction-list': transactionList,
      'date': date
    };
  }

  Future getLoanList(String username) async {
    var loanList = [];

    final response = await doc.ref
      .where('username', isEqualTo: username)
      .where('name', isEqualTo: 'Cho vay')
      .where('done', isEqualTo: false)
      .getDocuments();

    response.documents.forEach((doc) =>
      loanList.add(DebtTransactionModel.fromMap(doc.data, doc.documentID)));

    loanList.sort((a, b) => b.date.compareTo(a.date));
    return loanList;
  }

  Future insertTransaction(TransactionModel transaction) async {
    await doc.ref.add(transaction.toJson());
  }

  Future deleteTransaction(String id) async {
    await doc.ref.document(id).delete();
  }

  Future updateTransaction(TransactionModel transaction) async {
    await doc.ref.document(transaction.id).updateData(transaction.toJson());
  }
}
