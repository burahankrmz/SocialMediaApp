import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project2_social_media/services/firebase_operations.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String? userUid;
  String get getUserUid => userUid!;

  Future<String> logIntoAccount(String email, String password) async {
    try {
      final User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      //User user = userCredential.user!;
      userUid = user.uid;
      debugPrint(userUid);
      notifyListeners();
      return 'signedin';
      //ScaffoldSnackbar.of(context).show('${user.email} signed in');
    } on FirebaseAuthException catch (e) {
      //print('Failed with error code: ${e.code}');
      //print(e.message);
      if (e.code == "wrong-password") {
        return 'wrong-password';
      } else {
        return 'user-not-found';
      }
    }
  }

  Future createAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User user = userCredential.user!;
    userUid = user.uid;
    debugPrint(userUid);
    notifyListeners();
  }

  Future logOutViaEmail() async {
    return firebaseAuth.signOut();
  }

  Future signInWithGoogle() async {
    debugPrint('Sign in with google');
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);
    final User? user = userCredential.user;
    userUid = user!.uid;
    FirebaseOperations().createGoogleUserCollection(userUid!, {
      'useruid': userUid,
      'useremail': user.email,
      'username': user.displayName,
      'userimage': user.photoURL
    });

    debugPrint('Google User Uid => $userUid');
    notifyListeners();
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
