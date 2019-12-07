import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loginapp/ui/login_screen/login_screen.dart';

import 'info_card.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final googleSignIn = new GoogleSignIn();
  final facebookLogin = new FacebookLogin();
  final analytics = new FirebaseAnalytics();
  final auth = FirebaseAuth.instance;
  final reference = FirebaseDatabase.instance.reference().child('messages');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const List<String> choices = <String>[
    'Subscribe',
    'Settings',
    'SignOut'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              child: Image.asset('images/man.png', width: 80, height: 80),
            ),
            Text(
              'User',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
              ),
            ),
            InfoCard(
              text: 'email@gmail.com',
              icon: Icons.email,
              onPressed: () {},
            ),
            InfoCard(
              text: 'phone',
              icon: Icons.phone,
              onPressed: () {},
            ),
            InfoCard(
              text: 'address',
              icon: Icons.add_location,
              onPressed: () {},
            ),
            InfoCard(
              text: 'work',
              icon: Icons.add_location,
              onPressed: () {},
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: FlatButton(
                onPressed: signOut,
                child: Text('Sign out!',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  void signOut()async{
    var gg = _auth.currentUser;

   if (gg != null) {
     await googleSignIn.signOut();
     print("User Sign Out");
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(), fullscreenDialog: true));
  }

}
