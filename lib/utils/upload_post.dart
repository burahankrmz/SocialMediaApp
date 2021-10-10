import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:project2_social_media/constants/constantcolor.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  takeImage(BuildContext context) {
    return showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
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
                onTap: () {},
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
}
