import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/HomePage/homepage.dart';
import 'package:project2_social_media/screens/LandingPage/landing_page.dart';
import 'package:project2_social_media/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstantColors constantColors = ConstantColors();
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      debugPrint(FirebaseAuth.instance.currentUser!.uid.toString());
      Provider.of<FirebaseOperations>(context, listen: false)
          .alreadyLoginData(context);
      //debugPrint(FirebaseOperations().initUserEmail);
      Timer(
        const Duration(seconds: 3),
        () => Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const HomePage(), type: PageTransitionType.bottomToTop),
            (route) => false),
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          PageTransition(
              child: LandingPage(), type: PageTransitionType.leftToRight),
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
              text: 'Social',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Media',
                  style: TextStyle(
                    color: constantColors.blueColor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
