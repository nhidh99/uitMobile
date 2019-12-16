import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_grower/blocs/user_bloc.dart';
import 'package:money_grower/models/user_model.dart';
import 'package:money_grower/ui/main_screen/main_screen.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new LoginScreen());
  }
}

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);
  var user = UserModel();
  final userBloc = UserBloc();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkUserExist(LoginData data) async {
    final ref = Firestore.instance.collection("users");
    final response = await ref
        .where('username', isEqualTo: data.name)
        .limit(1)
        .getDocuments();
    print(response.documents.length);

    if(response.documents.length > 2){
      return false;
    }
    else if (response.documents.length < 1) {
      return false;
    }
    else {
      final json = response.documents.elementAt(0);
      if (json.data["username"] == data.name && json.data["password"] == data.password) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<String> authSignUp(LoginData data) async {
    user.username = data.name;
    user.income = 0;
    user.outgoings = 0;


    bool userExist = await checkUserExist(data);
    if(!userExist){
      return "Người dùng đã tồn tại! Xin vui lòng nhập người dùng khác";
    }

    userBloc.insertUser(user);
    print("Insert user " + user.username);

    try {
      FirebaseUser fbUser = (await _auth.createUserWithEmailAndPassword(
          email: data.name, password: data.password)).user;
      await fbUser.sendEmailVerification();
    }
    on PlatformException {
      return "Error";
    }
  }

  Future<String> _authUser(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');

    bool userExists = await checkUserExist(data);
    if (!userExists) {
      return "Người dùng không tồn tại hoặc bạn đã nhập sai tài khoản / mật khẩu."
          "Xin vui lòng kiểm tra lại tài khoản mật khẩu hoặc đăng kí tài khoản mới!";
    }
    await userBloc.getUserByUsername(data.name);
    _auth.signInWithEmailAndPassword(email: data.name, password: data.password);

    return Future.delayed(loginTime).then((_) {
      if (data.name != user.username) {
        return 'Tên đăng nhập không tồn tại';
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) async {
    print('Name: $name');
    user.username = name;

    await userBloc.getUserByUsername(name);
    await _auth.sendPasswordResetEmail(email: name);
    return Future.delayed(loginTime).then((_) {
      if (name != user.username) {
        return 'Tên đăng nhập không tồn tại';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        title: 'Money Grower',
        logo: 'assets/icon.png',
        onLogin: _authUser,
        onSignup: authSignUp,
        messages: LoginMessages(
          usernameHint: 'Tên đăng nhập',
          passwordHint: 'Mật khẩu',
          loginButton: 'Đăng nhập',
          signupButton: 'Đăng kí',
          recoverPasswordButton: 'Đổi mật khẩu',
          recoverPasswordIntro: 'Đừng lo, chúng tôi sẽ giúp bạn lấy lại mật khẩu ngay bây giờ !',
          recoverPasswordDescription: 'Chúng tôi sẽ gửi cho bạn 1 email để đổi mật khẩu, vui lòng kiểm tra lại email đã nhập và làm theo hướng dẫn!',
          recoverPasswordSuccess: 'Email đã được gửi đến hòm thư',
          goBackButton: 'Quay lại',
          forgotPasswordButton: 'Quên mật khẩu ?',
        ),
        onSubmitAnimationCompleted: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => new MoneyGrowerApp(user.username)));
        },
        onRecoverPassword: _recoverPassword,
      ),
    );
  }
}
