import 'package:flutter/material.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/Feed/feed.dart';
import 'package:project2_social_media/screens/HomePage/homepage_helpers.dart';
import 'package:project2_social_media/screens/LandingPage/landing_utils.dart';
import 'package:project2_social_media/screens/Profile/baseprofile.dart';
import 'package:project2_social_media/screens/Search/search.dart';
import 'package:project2_social_media/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    Provider.of<LandingUtils>(context, listen: false).userAvatar = null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: PageView(
        controller: homepageController,
        children: [
          Feed(),
          const SearchPage(),
          BaseProfile(),
        ],
        physics: const ScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: HomePageHelpers()
          .bottomNavBar(pageIndex, homepageController, context),
    );
  }
}
