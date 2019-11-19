import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_grower/api/api.dart';
import '../models/user_model.dart';

class UserApiProvider {

  final api = Api('notes', 'nhidh99');

  Future<List<UserModel>> getUserList() async {
    final response = await api.getDataCollection();
    final notes = response.documents
      .map((doc) => UserModel.fromMap(doc.data, doc.documentID)).toList();
    return notes;
  }

  Stream<QuerySnapshot> getUserListAsStream() {
    return api.streamDataCollection();
  }

  Future updateUser(UserModel data, String id) async {
    await api.updateDocument(data.toJson(), id);
  }

  Future insertUser(UserModel data) async {
    await api.addDocument(data.toJson());
  }
}