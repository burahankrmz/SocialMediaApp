import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project2_social_media/screens/LandingPage/landing_utils.dart';
import 'package:project2_social_media/services/authentication.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  late UploadTask imageUploadTask;
  String? initUserEmail, initUserName, initUserImage;
  String get getInitUserImage => initUserImage!;

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() {
      debugPrint('image uploaded');
    });
    imageReference.getDownloadURL().then((url) {
      debugPrint(url);
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();

      debugPrint('the user profile avatar url => $url');
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future createGoogleUserCollection(String googleUid,dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(googleUid)
        .set(data);
  }

  Future initUserData(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      debugPrint('fetcing user data');
      initUserName = doc.data()!['username'];
      initUserEmail = doc.data()!['useremail'];
      initUserImage = doc.data()!['userimage'];
      debugPrint(
          'fetched user data \n $initUserEmail \n $initUserName \n $initUserImage');
      notifyListeners();
    });
  }

  Future initUserData2() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      debugPrint('fetcing user data');
      initUserName = doc.data()!['username'];
      initUserEmail = doc.data()!['useremail'];
      initUserImage = doc.data()!['userimage'];
      debugPrint(
          'fetched user data \n $initUserEmail \n $initUserName \n $initUserImage');
      notifyListeners();
    });
  }

  Future alreadyLoginData(BuildContext context) {
    debugPrint(FirebaseAuth.instance.currentUser!.uid);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      debugPrint('fetcing user data');
      initUserName = doc.data()!['username'];
      initUserEmail = doc.data()!['useremail'];
      initUserImage = doc.data()!['userimage'];
      debugPrint(
          'fetched user data \n $initUserEmail \n $initUserName \n $initUserImage');
      notifyListeners();
    });
  }
}
