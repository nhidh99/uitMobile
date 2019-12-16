import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_grower/ui/login_screen/welcome_screen.dart';
import 'package:money_grower/ui/main_screen/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppState(),
    );
  }
}


class MyAppState extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
          if (snapshot.hasData){
            FirebaseUser user = snapshot.data; // this is your user instance
            /// is because there is user already logged
            print(snapshot.data.email);
            return MoneyGrowerApp(snapshot.data.email);
          }
          /// other way there is no user logged.
          return LoginScreen();
        }
    );
  }
}