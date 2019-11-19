class UserModel {
  String id;
  String username;
  int income;
  int outgoings;

  UserModel(this.username, this.income, this.outgoings);

  UserModel.fromMap(Map snapshot, String id) {
    this.id = id;
    this.username = snapshot['username'];
    this.income = snapshot['income'];
    this.outgoings = snapshot['outgoings'];
  }

  toJson() {
    return {
      "username": username,
      "income": income,
      "outgoings": outgoings
    };
  }
}