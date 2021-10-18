import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class HomePageHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  late DocumentSnapshot userData;
  Widget bottomNavBar(
      int index, PageController pageController, BuildContext context) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      borderRadius: const Radius.circular(30.0),
      selectedColor: const Color(0xff040307),
      unSelectedColor: constantColors.greyColor,
      elevation: 100.0,
      strokeColor: constantColors.darkColor,
      scaleFactor: 0.3,
      iconSize: 30.0,
      onTap: (value) {
        index = value;
        pageController.jumpToPage(value);
        notifyListeners();
      },
      backgroundColor: constantColors.whiteColor,
      //const Color(0xff040307),
      items: [
        CustomNavigationBarItem(
          icon: const Icon(EvaIcons.home),
        ),
        CustomNavigationBarItem(
          icon: const Icon(Icons.message_rounded),
        ),
        CustomNavigationBarItem(
          icon: CircleAvatar(
            radius: 35.0,
            backgroundImage: NetworkImage(
                Provider.of<FirebaseOperations>(context, listen: false)
                    .getInitUserImage),
          ),
        ),
      ],
    );
  }
}
