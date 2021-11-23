import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:provider/provider.dart';

import 'baseprofile_helpers.dart';

// ignore: must_be_immutable
class ProfileOtherUsers extends StatelessWidget {
  ProfileOtherUsers({Key? key, required this.userUid}) : super(key: key);
  final ConstantColors constantColors = ConstantColors();
  String userUid;

  @override
  Widget build(BuildContext context) {
    dynamic userData;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: 'Social ',
                style: TextStyle(
                    color: constantColors.darkColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Media',
                style: TextStyle(
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0),
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: constantColors.darkColor,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            userData = snapshot.data!.data();
            return CustomScrollView(
              slivers: [
                Provider.of<BaseProfileHelpers>(context, listen: false)
                    .infoContainer(context, userData),
                Provider.of<BaseProfileHelpers>(context, listen: false)
                    .posts(context, snapshot.data!.data()),
              ],
            );
          }
        },
      ),
    );
  }
}
