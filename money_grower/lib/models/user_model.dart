class UserModel {
  String id;
  String username;
  int income;

  static final UserModel _instance = UserModel._internal();
  UserModel._internal();

  factory UserModel() {
    return _instance;
  }

  UserModel.fromMap(Map snapshot, String id) {
    _instance.id = id;
    _instance.username = snapshot['username'];
    _instance.income = snapshot['income'];
  }

  toJson() {
    return {
      "username": username,
      "income": income
    };
  }
}