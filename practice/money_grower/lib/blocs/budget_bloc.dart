import 'package:money_grower/models/budget_model.dart';
import 'package:money_grower/resources/repository.dart';

class BudgetBloc {
  final repository = Repository();

  Future getBudgetsByUsername(String username) =>
      repository.getBudgetsByUsername(username);

  Future insertBudget(BudgetModel budget) => repository.insertBudget(budget);

  Future deleteBudget(String id) => repository.deleteBudget(id);
}
