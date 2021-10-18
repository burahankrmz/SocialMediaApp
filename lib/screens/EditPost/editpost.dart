import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/LandingPage/landing_services.dart';
import 'package:project2_social_media/services/firebase_operations.dart';
import 'package:project2_social_media/utils/upload_post.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditPost extends StatelessWidget {
  EditPost({Key? key}) : super(key: key);
  final ConstantColors constantColors = ConstantColors();
  final TextEditingController captionController = TextEditingController();
  String? postImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Provider.of<UploadPost>(context, listen: false).uploadPostImage =
                null;
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: constantColors.darkColor),
        ),
        title: Text(
          'New Post',
          style: TextStyle(color: constantColors.darkColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<UploadPost>(context, listen: false)
                  .uploadPostImageToFirebase()
                  .whenComplete(() async {
                debugPrint(Provider.of<UploadPost>(context, listen: false)
                    .uploadPostImageUrl);
                Provider.of<FirebaseOperations>(context, listen: false)
                    .uploadPosts(captionController.text, {
                  'caption': captionController.text,
                  'postimage': Provider.of<UploadPost>(context, listen: false)
                      .uploadPostImageUrl,
                  'username':
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getInitUserName,
                  'userimage':
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getInitUserImage,
                  'useruid': FirebaseAuth.instance.currentUser!.uid,
                  'time': Timestamp.now(),
                  'useremail':
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getInitUserEmail
                }).whenComplete(() async {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('posts')
                      .add({
                    'caption': captionController.text,
                    'postimage': Provider.of<UploadPost>(context, listen: false)
                        .uploadPostImageUrl,
                    'username':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserName,
                    'userimage':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserImage,
                    'useruid': FirebaseAuth.instance.currentUser!.uid,
                    'time': Timestamp.now(),
                    'useremail':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserEmail
                  }).whenComplete(() {
                    captionController.clear();
                    Navigator.pop(context);
                    Provider.of<LandingService>(context, listen: false)
                        .warningText(context, 'Post Uploaded Successfully.');
                  });
                });
              });
            },
            icon: const Icon(Icons.check, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(
                    Provider.of<UploadPost>(context, listen: false)
                        .getUploadPostImage,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: captionController,
                  minLines: 7,
                  maxLines: 7,
                  maxLength: 255,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    focusColor: constantColors.darkColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: constantColors.darkColor),
                    ),
                    hintText: 'Caption...',
                    labelText: 'Post Caption',
                    floatingLabelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
