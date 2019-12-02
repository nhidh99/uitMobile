import 'package:money_grower/models/user_model.dart';

class TransactionModel {
  String id;
  String name;
  String note;
  DateTime date;
  int price;

  TransactionModel(this.id, this.name, this.note, this.price, this.date);

  TransactionModel.fromMap(Map snapshot, String id) {
    this.id = id;
    this.name = snapshot['name'];
    this.note = snapshot['note'];
    this.price = snapshot['price'];
    this.date =
        DateTime.fromMillisecondsSinceEpoch(snapshot['date'].seconds * 1000);
  }

  toJson() {
    return {
      "date": date,
      "date-month": date.month,
      "date-year": date.year,
      "username": UserModel().username,
      "name": name,
      "note": note,
      "price": price
    };
  }
}

class DebtTransactionModel extends TransactionModel {
  bool done = false;

  DebtTransactionModel(
      String id, String name, String note, int price, DateTime date)
      : super(id, name, note, price, date);

  @override
  DebtTransactionModel.fromMap(Map snapshot, String id)
      : super(
            id,
            snapshot['name'],
            snapshot['note'],
            snapshot['price'],
            DateTime.fromMillisecondsSinceEpoch(
                snapshot['date'].seconds * 1000)) {
    this.done = snapshot['done'];
  }

  @override
  toJson() {
    return {
      "date": date,
      "date-month": date.month,
      "date-year": date.year,
      "username": UserModel().username,
      "name": name,
      "note": note,
      "price": price,
      "done": done
    };
  }
}
