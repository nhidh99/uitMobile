import 'dart:async';
import 'package:money_grower/resources/user_provider.dart';
import '../models/user_model.dart';

class Repository {

  final userApiProvider = UserApiProvider();
  Future getUserByUsername(String username) => userApiProvider.getUserByUsername(username);
  Future insertUser(UserModel data) => userApiProvider.insertUser(data);
  Future updateUser(UserModel data, String id) => userApiProvider.updateUser(data, id);
}