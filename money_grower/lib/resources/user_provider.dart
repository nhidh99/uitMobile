import 'dart:async';
import 'package:money_grower/helper/doc_helper.dart';
import '../models/user_model.dart';

class UserProvider {

  final doc = DocHelper('users');

  Future getUserByUsername(String username) async {
    final response = await doc.ref.where('username', isEqualTo: username).limit(1).getDocuments();
    if (response.documents.isEmpty) return null;
    final json = response.documents.elementAt(0);
    return UserModel.fromMap(json.data, json.documentID);
  }

  Future updateUser(UserModel data) async {
    await doc.ref.document(data.id).updateData(data.toJson());
  }

  Future insertUser(UserModel data) async {
    await doc.ref.add(data.toJson());
  }
}