import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/Authentication/Login/loginpage.dart';
import 'package:project2_social_media/screens/HomePage/homepage.dart';
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
                        child: const LoginPage(),
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
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          icon: Icon(
            Icons.arrow_back,
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
            return CustomScrollView(
              slivers: [
                Provider.of<BaseProfileHelpers>(context, listen: false)
                    .infoContainer(context, snapshot.data!.data(), 'xd'),
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
