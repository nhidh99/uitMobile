import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_grower/blocs/user_bloc.dart';
import 'package:money_grower/models/user_model.dart';
import 'package:money_grower/ui/custom_control/faded_transition.dart';
import 'package:money_grower/ui/main_screen/main_screen.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);
  final user = UserModel();
  final userBloc = UserBloc();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkUserExist(LoginData data) async {
    final user = await userBloc.getUserByUsername(data.name);
    return user != null;
  }

  // ignore: missing_return
  Future<String> authSignUp(LoginData data) async {
    user.username = data.name;
    user.income = 0;

    bool userExist = await checkUserExist(data);
    if (userExist) {
      return "Tên người dùng đã tồn tại!";
    } else {
      userBloc.insertUser(user);
      try {
        FirebaseUser fbUser = (await _auth.createUserWithEmailAndPassword(
                email: data.name, password: data.password))
            .user;
        await fbUser.sendEmailVerification();
      } on PlatformException {
        return "Lỗi đăng nhập!";
      }
    }
  }

  // ignore: missing_return
  Future<String> _authUser(LoginData data) async {
    bool userExists = await checkUserExist(data);
    if (!userExists) {
      return "Email không tồn tại";
    }
    try {
      await _auth.signInWithEmailAndPassword(
          email: data.name, password: data.password);
      user.username = data.name;
    } on Exception {
      return 'Sai tên tài khoản/mật khẩu';
    }
  }

  Future<String> _recoverPassword(String name) async {
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
    return Container(
      color: Colors.green,
      padding: EdgeInsets.only(top: 50),
      child: FlutterLogin(
        title: 'MoneyGrower',
        logo: 'assets/coins.png',
        onLogin: _authUser,
        onSignup: authSignUp,
        messages: LoginMessages(
            usernameHint: 'Email',
            passwordHint: 'Mật khẩu',
            confirmPasswordHint: "Nhập lại mật khẩu",
            confirmPasswordError: "Mật khẩu không khớp",
            loginButton: 'Đăng nhập',
            signupButton: 'Đăng kí',
            recoverPasswordButton: 'Đổi mật khẩu',
            recoverPasswordIntro:
                'Đừng lo, chúng tôi sẽ giúp bạn lấy lại mật khẩu ngay bây giờ!',
            recoverPasswordDescription:
                'Chúng tôi sẽ gửi cho bạn một email\nhỗ trợ đổi mật khẩu!',
            recoverPasswordSuccess: 'Email đổi mật khẩu đã được gửi',
            goBackButton: 'Quay lại',
            forgotPasswordButton: 'Quên mật khẩu?'),
        onSubmitAnimationCompleted: () {
          screenIndex = 0;
          Navigator.of(context).pushAndRemoveUntil(
              FadeRoute(page: MoneyGrowerApp()),
              (Route<dynamic> route) => false);
        },
        onRecoverPassword: _recoverPassword,
      ),
    );
  }
}
