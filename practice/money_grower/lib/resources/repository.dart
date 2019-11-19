import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_grower/resources/user_provider.dart';
import '../models/user_model.dart';

class Repository {

  final userApiProvider = UserApiProvider();

  Future<List<UserModel>> getUserList() => userApiProvider.getUserList();
  Stream<QuerySnapshot> getUserListAsStream() => userApiProvider.getUserListAsStream();
  Future insertUser(UserModel data) => userApiProvider.insertUser(data);
  Future updateUser(UserModel data, String id) => userApiProvider.updateUser(data, id);
}