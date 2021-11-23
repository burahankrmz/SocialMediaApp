import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/LandingPage/landing_page.dart';
import 'package:project2_social_media/screens/Profile/baseprofile_helpers.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BaseProfile extends StatelessWidget {
  BaseProfile({Key? key}) : super(key: key);
  final ConstantColors constantColors = ConstantColors();
  late DocumentSnapshot userData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: 'My ',
                style: TextStyle(
                    color: constantColors.darkColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Profile',
                style: TextStyle(
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().whenComplete(() {
                Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                        child: LandingPage(),
                        type: PageTransitionType.bottomToTop),
                    (route) => false);
              });
            },
            icon: Icon(
              Icons.exit_to_app,
              color: constantColors.darkColor,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.settings,
            color: constantColors.darkColor,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //userData = snapshot.data.docs;
            //userData = snapshot.data.docs;
            return CustomScrollView(
              slivers: [
                Provider.of<BaseProfileHelpers>(context, listen: false)
                    .infoContainer(context, snapshot.data!.data()),
                Provider.of<BaseProfileHelpers>(context, listen: false)
                    .posts(context, snapshot.data!.data()),
                // Provider.of<ProfileHelpers>(context, listen: false)
                //     .infoContainerv2(context, snapshot.data!.docs[0]),
                // Provider.of<ProfileHelpers>(context, listen: false)
                //     .myPosts(context, snapshot),
              ],
            );
          }
        },
      ),
    );
  }
}

/*
StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('posts')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            else {
              snapshot.data.
            }
          },
        ));
*/
