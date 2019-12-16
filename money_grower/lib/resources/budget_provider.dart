import 'package:money_grower/helper/doc_helper.dart';
import 'package:money_grower/models/budget_model.dart';
import 'package:money_grower/models/transaction_model.dart';

class BudgetProvider {
  final doc = DocHelper('budgets');

  Future getBudgetsByUsername(String username) async {
    var budgets = [];
    final response =
        await doc.ref.where('username', isEqualTo: username).getDocuments();
    response.documents.forEach(
        (doc) => budgets.add(BudgetModel.fromMap(doc.data, doc.documentID)));
    return budgets;
  }

  Future insertBudget(BudgetModel budget) async =>
      await doc.ref.add(budget.toJson());

  Future deleteBudget(String id) async => await doc.ref.document(id).delete();

  Future updateBudget(BudgetModel budget) async =>
      await doc.ref.document(budget.id).updateData(budget.toJson());

  Future getBudgetByName(String name, String username) async {
    final response = await doc.ref
        .where('username', isEqualTo: username)
        .where('name', isEqualTo: name)
        .getDocuments();
    if (response.documents.isEmpty) return null;
    final output = response.documents[0];
    return BudgetModel.fromMap(output.data, output.documentID);
  }

  Future getMatchBudgetByTransaction(
      TransactionModel transaction, String username) async {
    final response = await doc.ref
        .where('username', isEqualTo: username)
        .where('name', isEqualTo: transaction.name)
        .getDocuments();

    if (response.documents.isEmpty) return null;
    final output = response.documents[0];
    final budget = BudgetModel.fromMap(output.data, output.documentID);

    if (budget.beginDate.compareTo(transaction.date) <= 0
    && budget.endDate.compareTo(transaction.date) >= 0) {
      return budget;
    }
    return null;
  }
}
