import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'new_user_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        color: Colors.green[500],
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: 400,
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(children: <Widget>[
                      Material(
                          elevation: 20.0,
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/coins.png',
                              width: 80,
                              height: 80,
                            ),
                          )),
                      SizedBox(height: 20),
                      Text("MoneyGrower",
                          style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontFamily: "Arial",
                              fontWeight: FontWeight.bold))
                    ]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: SizedBox(
                            width: 250,
                            height: 50,
                            child: FacebookSignInButton(
                              text: "Sign in with Facebook",
                              onPressed: loginWithFacebook,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                              width: 250,
                              height: 50,
                              child: GoogleSignInButton(
                                onPressed: signInWithGoogle,
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void checkUser() async {
    final ref = Firestore.instance.collection("users");
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final response = await ref
        .where('username', isEqualTo: user.uid)
        .limit(1)
        .getDocuments();

    if (response.documents.length < 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddNewUserScreen(),
              fullscreenDialog: true));
    } else {
      final json = response.documents.elementAt(0);
      if (json.data["username"] == user.uid) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddNewUserScreen(),
                fullscreenDialog: true));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddNewUserScreen(),
                fullscreenDialog: true));
      }
    }
  }

  Future<String> signInWithGoogle() async {
    final googleSignIn = new GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final _auth = FirebaseAuth.instance;
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    checkUser();
    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    final googleSignIn = new GoogleSignIn();
    await googleSignIn.signOut();
  }

  Future<void> loginWithFacebook() async {
    final facebookLogin = new FacebookLogin();
    final facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;

      case FacebookLoginStatus.loggedIn:
        await firebaseAuthWithFacebook(token: facebookLoginResult.accessToken);
        checkUser();
    }
  }

  Future<FirebaseUser> firebaseAuthWithFacebook(
      {@required FacebookAccessToken token}) async {
    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: token.token);
    FirebaseUser firebaseUser =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    return firebaseUser;
  }
}
