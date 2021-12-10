import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/services/firebase_operations.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  String? imageTimePosted;
  String get getImageTimePosted => imageTimePosted!;

  showTimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    debugPrint(imageTimePosted);
    notifyListeners();
    return imageTimePosted;
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    debugPrint(subDocId);
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': FirebaseAuth.instance.currentUser!.uid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  Future removeLike(
      BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .delete();
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': FirebaseAuth.instance.currentUser!.uid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  Future<bool?> onLikeButtonTapped(bool isLiked) async {
    return !isLiked;
  }

  showPostOptions(
      BuildContext context, QueryDocumentSnapshot<Object?> userDatav2) {
    return showModalBottomSheet(
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        barrierColor: Colors.black.withOpacity(0.2),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: constantColors.blueColor,
                ),
                title: Text(
                  'Delete Post',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.darkColor),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete This Post?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black)),
                          actions: [
                            MaterialButton(
                              child: const Text('No',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.grey)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            MaterialButton(
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.blue),
                              ),
                              onPressed: () {
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .removePosts(userDatav2)
                                    .whenComplete(() {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  warningText(context, 'Deleted Successfully');
                                });
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: constantColors.blueColor,
                ),
                title: Text(
                  'Edit Caption',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.darkColor),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.cancel,
                  color: constantColors.darkColor,
                ),
                title: Text(
                  'Cancel',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.darkColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: constantColors.darkColor,
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          );
        });
  }
}
