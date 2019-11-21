class TransactionModel {
  String id;
  String name;
  String note;
  String username;
  DateTime date;
  int price;

  TransactionModel(this.id, this.name, this.note, this.username, this.price);

  TransactionModel.fromMap(Map snapshot, String id) {
    this.id = id;
    this.name = snapshot['name'];
    this.note = snapshot['note'];
    this.username = snapshot['username'];
    this.price = snapshot['price'];
    this.date = DateTime(
        snapshot['date-year'], snapshot['date-month'], snapshot['date-day']);
  }

  toJson() {
    return {
      "name": name,
      "username": username,
      "note": note,
      "date": date,
      "price": price
    };
  }
}
