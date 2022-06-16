import 'package:barber/pages/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyProviders extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);

    notifyListeners();
  }

  Future logout() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signOut()
          .then((value) => print("loout success"));
    });
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Future logoutBB(cont) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signOut()
          .then((value) => Navigator.pushAndRemoveUntil(
              cont,
              MaterialPageRoute(
                builder: (context) => IndexPage(),
              ),
              (route) => false));
    });
  }

  Future facebookLogin() async {
    final LoginResult result = await FacebookAuth.instance.login();
  }
}
