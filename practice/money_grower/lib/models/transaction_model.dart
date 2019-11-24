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
    this.date = DateTime(
        snapshot['date-year'], snapshot['date-month'], snapshot['date-day']);
  }

  toJson() {
    return {
      "date-day": date.day,
      "date-month": date.month,
      "date-year": date.year,
      "username": UserModel().username,
      "name": name,
      "note": note,
      "price": price
    };
  }
}
