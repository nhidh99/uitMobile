import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:money_grower/blocs/user_bloc.dart';
import 'package:money_grower/models/user_model.dart';
import 'package:money_grower/ui/main_screen/main_screen.dart';

class AddNewUserScreen extends StatefulWidget {
  @override
  _AddNewUserScreenState createState() => _AddNewUserScreenState();
}

class _AddNewUserScreenState extends State<AddNewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Tạo người dùng mới "),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/coins.png',
              width: 80,
              height: 80,
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Vui lòng nhập vào số dương !';
                }
                return value;
              },
              controller: textController,
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () async {
                  final userBloc = UserBloc();
                  final FirebaseUser curUser =
                      await FirebaseAuth.instance.currentUser();
                  UserModel().username = curUser.uid;
                  UserModel().income = int.parse(textController.text);
                  UserModel().outgoings = 0;
                  userBloc.insertUser(UserModel());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MoneyGrowerApp(),
                          fullscreenDialog: true));
                },
                child: Text('Xác nhận'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
