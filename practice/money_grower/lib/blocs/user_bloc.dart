import 'package:loginapp/models/user_model.dart';
import 'package:loginapp/resources/repository.dart';


class UserBloc {
  final repository = Repository();
  Future getUserByUsername(String username) => repository.getUserByUsername(username);
  Future insertUser(UserModel data) => repository.insertUser(data);
  Future updateUser(UserModel data, String id) => repository.updateUser(data, id);
  Future isUserExist(String uid) => repository.isUserExist(uid);
}