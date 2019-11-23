class TransactionModel {
  String id;
  String name;
  String note;
  DateTime date;
  int price;

  TransactionModel(this.id, this.name, this.note, this.price);

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
      "name": name,
      "note": note,
      "date": date,
      "price": price
    };
  }
}
