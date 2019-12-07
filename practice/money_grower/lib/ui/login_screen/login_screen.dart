import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:loginapp/blocs/user_bloc.dart';
import 'package:loginapp/ui/home_screen/main_screen.dart';
import 'package:loginapp/ui/login_screen/add_new_user.dart';



class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final googleSignIn = new GoogleSignIn();
  final facebookLogin = new FacebookLogin();
  final analytics = new FirebaseAnalytics();
  final auth = FirebaseAuth.instance;
  final reference = FirebaseDatabase.instance.reference();
  final ref = Firestore.instance.collection("users");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> listUser = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(77, 213, 153, 1),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              widthFactor: 0.6,
              heightFactor: 0.6,
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(200)),
                color: Color.fromRGBO(255, 255, 255, 0.4),
                child: Container(
                  width: 400,
                  height: 400,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              widthFactor: 0.5,
              heightFactor: 0.6,
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(200)),
                color: Color.fromRGBO(255, 255, 255, 0.4),
                child: Container(
                  width: 400,
                  height: 400,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 400,
                height: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Material(
                        elevation: 20.0,
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('images/coins.png',width: 80,height:80,),
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only( bottom : 10.0),
                          child:  SizedBox(
                            width: MediaQuery.of(context).size.width * 2/3,
                            child: FacebookSignInButton(
                              onPressed: _loginWithFacebook,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child:  SizedBox(
                              width: MediaQuery.of(context).size.width * 2/3,
                              child: GoogleSignInButton(
                                onPressed: signInWithGoogle,
                              )
                          ),
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
    );
  }

  void navigateToHomePage(){
    print("HomePage");
    Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleNoteApp(), fullscreenDialog: true));
  }

  void navigateAddUser(){
    print("AddUser");
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewUserScreen(), fullscreenDialog: true));
  }

  void checkUser() async {
    final FirebaseUser curUser = await FirebaseAuth.instance.currentUser();
    final response = await ref.where('username', isEqualTo: curUser.uid).limit(1).getDocuments();

    if(response.documents.length < 1){
      navigateAddUser();
    }
    else{
      final json = response.documents.elementAt(0);
      print(json.data["username"]);
      if(json.data["username"] == curUser.uid){
        navigateToHomePage();
      }
      else
        navigateAddUser();
    }
  }


  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    checkUser();
    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async{
    await googleSignIn.signOut();

    print("User Sign Out");
  }
  Future<void> _loginWithFacebook() async {
    final facebookLogin = new FacebookLogin();

    final facebookLoginResult = await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print(facebookLoginResult.errorMessage);
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;

      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        /// calling the auth mehtod and getting the logged user
        var firebaseUser = await firebaseAuthWithFacebook(
            token: facebookLoginResult.accessToken);
        checkUser();
    }
  }

  Future<FirebaseUser> firebaseAuthWithFacebook({@required FacebookAccessToken token}) async {
    AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: token.token);
    FirebaseUser firebaseUser = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    return firebaseUser;
  }
}



