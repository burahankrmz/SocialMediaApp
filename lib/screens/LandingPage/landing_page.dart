import 'package:flutter/material.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/LandingPage/landing_helpers.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);
  final ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [
          bodyColor(),
          Provider.of<LandingHelpers>(context, listen: false)
              .bodyImage(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .taglineText(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .mainButtons(context),
        ],
      ),
    );
  }

  Widget bodyColor() {
    return Container(
      decoration: BoxDecoration(
        //color: constantColors.whiteColor,
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.5, 0.9],
            colors: [constantColors.darkColor, constantColors.blueGreyColor]),
      ),
    );
  }
}
