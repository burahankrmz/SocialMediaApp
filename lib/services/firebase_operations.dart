import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project2_social_media/screens/LandingPage/landing_utils.dart';
import 'package:project2_social_media/services/authentication.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  String? postId;
  late UploadTask imageUploadTask;
  List followers = [];
  List get getFollowers => followers;

  set setFollowers(List followers) => this.followers = followers;
  String? initUserEmail, initUserName, initUserImage;
  String get getInitUserImage => initUserImage!;
  String get getInitUserName => initUserName!;
  String get getInitUserEmail => initUserEmail!;

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference
        .putFile(Provider.of<LandingUtils>(context, listen: false).userAvatar!);
    await imageUploadTask.whenComplete(() {
      debugPrint('image uploaded');
    });
    Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
        await imageReference.getDownloadURL();
    debugPrint(Provider.of<LandingUtils>(context, listen: false)
        .userAvatarUrl
        .toString());
    debugPrint('OLDU GIBI NE DIYON');
    notifyListeners();
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data)
        .whenComplete(() {
      debugPrint('created Succesfully');
    });
  }

  Future createGoogleUserCollection(String googleUid, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(googleUid)
        .set(data);
  }

  Future initUserData(BuildContext context) {
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

  Future uploadPosts(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future updateCaption(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future followUser(
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }

  Future removeFollowing(userData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('following')
        .doc(userData['useruid'])
        .delete()
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userData['useruid'])
          .collection('followers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
    });
  }

  Future removePosts(postData) async {
    debugPrint(postData['caption']);
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postData['caption'])
        .delete()
        .whenComplete(() {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('posts')
          .where('caption', isEqualTo: postData['caption'])
          .get()
          .then((value) {
        debugPrint('ABCDE' + value.docs.first.id);
        postId = value.docs.first.id;
      }).whenComplete(() {
        debugPrint(postId);
        return FirebaseFirestore.instance
            .collection('users')
            .doc(postData['useruid'])
            .collection('posts')
            .doc(postId)
            .delete();
      });
    });
  }


}
