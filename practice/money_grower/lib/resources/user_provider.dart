import 'dart:async';
import 'package:money_grower/api/doc_api.dart';
import '../models/user_model.dart';

class UserApiProvider {

  final doc = Document('users');

  Future getUserByUsername(String username) async {
    final response = await doc.ref.where('username', isEqualTo: username).limit(1).getDocuments();
    final json = response.documents.elementAt(0);
    UserModel.fromMap(json.data, json.documentID);
  }

  Future updateUser(UserModel data, String id) async {
    await doc.ref.document(id).updateData(data.toJson());
  }

  Future insertUser(UserModel data) async {
    await doc.ref.add(data.toJson());
  }
}