import 'package:money_grower/models/user_model.dart';

class BudgetModel {
  String id;
  String name;
  DateTime beginDate;
  DateTime endDate;
  int totalBudget;
  int totalUsed;

  BudgetModel(this.id, this.name, this.beginDate, this.endDate,
      this.totalBudget, this.totalUsed);

  BudgetModel.fromMap(Map snapshot, String id) {
    this.id = id;
    this.name = snapshot['name'];
    this.beginDate = DateTime.fromMillisecondsSinceEpoch(snapshot['date-begin'].seconds * 1000);
    this.endDate = DateTime.fromMillisecondsSinceEpoch(snapshot['date-end'].seconds * 1000);
    this.totalBudget = snapshot['total-budget'];
    this.totalUsed = snapshot['total-used'];
  }

  toJson() {
    return {
      'name': name,
      'date-begin': beginDate,
      'date-end': endDate,
      'total-budget': totalBudget,
      'total-used': totalUsed,
      'username': UserModel().username
    };
  }
}
