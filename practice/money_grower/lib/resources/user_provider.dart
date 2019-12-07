import 'dart:async';
import 'package:loginapp/helper/doc_helper.dart';
import '../models/user_model.dart';

class UserProvider {

  final doc = DocHelper('users');

  Future getUserByUsername(String username) async {
    final response = await doc.ref.where('username', isEqualTo: username).limit(1).getDocuments();
    final json = response.documents.elementAt(0);
    UserModel.fromMap(json.data, json.documentID);
  }

  Future isUserExist(String uid) async {
    var isContain = false;
    final response = await doc.ref.getDocuments();
    List<String> userNameList = [];
    response.documents.forEach((doc) {
      final uid = doc.data["username"];
      userNameList.add(uid);
    });

    isContain = userNameList.contains(uid);

    return{
      'isContained' : isContain,
    };
  }

  Future updateUser(UserModel data, String id) async {
    await doc.ref.document(id).updateData(data.toJson());
  }

  Future insertUser(UserModel data) async {
    await doc.ref.add(data.toJson());
  }
}
