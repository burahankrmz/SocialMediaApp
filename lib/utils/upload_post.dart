import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
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
  late String uploadPostImageUrl;
  String get getUploadPostImageUrl => uploadPostImageUrl;
  late UploadTask postImageUploadTask;

  Future pickPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    uploadPostImageVal == null
        ? debugPrint('Select image')
        : uploadPostImage = File(uploadPostImageVal.path);
    //print(uploadPostImageVal!.path);
    /*
    uploadPostImage != null
        ? Provider.of<UploadPost>(context, listen: false).showPostImage(context)
        : debugPrint('image upload error');
        */

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

    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      debugPrint(uploadPostImageUrl);
    });
    notifyListeners();
  }

  takeImage(BuildContext context) {
    return showModalBottomSheet(
        enableDrag: false,
        //isDismissible: false,
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

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                SizedBox(
                  height: 200.0,
                  width: 400.0,
                  child: Image.file(
                    uploadPostImage!,
                    fit: BoxFit.contain,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Reselect',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: constantColors.whiteColor,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      onPressed: () {
                        uploadPostImageToFirebase().whenComplete(() {
                          debugPrint('Image Uploaded');
                        });
                      },
                      child: Text(
                        'Confirm Image',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          decorationColor: constantColors.whiteColor,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  editPOstSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: constantColors.whiteColor),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextField(
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
                      alignLabelWithHint: false,
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: constantColors.darkColor,
                      fontWeight: FontWeight.bold,
                      decorationColor: constantColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
