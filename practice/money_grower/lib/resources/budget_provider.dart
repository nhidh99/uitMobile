import 'package:money_grower/helper/doc_helper.dart';
import 'package:money_grower/models/budget_model.dart';

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
}
