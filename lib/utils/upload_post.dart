import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/EditPost/editpost.dart';
import 'package:provider/provider.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final ImagePicker picker = ImagePicker();
  File? uploadPostImage;
  File get getUploadPostImage => uploadPostImage!;
  String? uploadPostImageUrl;
  String get getUploadPostImageUrl => uploadPostImageUrl!;
  late UploadTask postImageUploadTask;

  Future pickPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    uploadPostImageVal == null
        ? debugPrint('Select image')
        : uploadPostImage = File(uploadPostImageVal.path);

    notifyListeners();
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage!.path}/${TimeOfDay.now()}');

    postImageUploadTask = imageReference.putFile(uploadPostImage!);
    await postImageUploadTask.whenComplete(() {
      debugPrint('Picture uploaded successfully');
    });
    await imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      debugPrint(uploadPostImageUrl);
    });

    notifyListeners();
  }

  takeImage(BuildContext context) {
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
                  Icons.camera,
                  color: constantColors.blueColor,
                ),
                title: Text(
                  'Capture With Camera',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.darkColor),
                ),
                onTap: () {
                  Provider.of<UploadPost>(context, listen: false)
                      .pickPostImage(context, ImageSource.camera)
                      .whenComplete(() {
                    if (uploadPostImage != null) {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: EditPost(),
                              type: PageTransitionType.bottomToTop));
                      uploadPostImage == null;
                    }
                  });
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.panorama,
                  color: constantColors.blueColor,
                ),
                title: Text(
                  'Select from Gallery',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.darkColor),
                ),
                onTap: () {
                  Provider.of<UploadPost>(context, listen: false)
                      .pickPostImage(context, ImageSource.gallery)
                      .whenComplete(() {
                    if (uploadPostImage != null) {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: EditPost(),
                              type: PageTransitionType.bottomToTop));
                      uploadPostImage == null;
                    }
                  });
                },
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
}
