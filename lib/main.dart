import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/Feed/feed_helpers.dart';
import 'package:project2_social_media/screens/FollowPage/followpage_helpers.dart';
import 'package:project2_social_media/screens/HomePage/homepage_helpers.dart';
import 'package:project2_social_media/screens/LandingPage/landing_helpers.dart';
import 'package:project2_social_media/screens/LandingPage/landing_services.dart';
import 'package:project2_social_media/screens/LandingPage/landing_utils.dart';
import 'package:project2_social_media/screens/PostComments/postcomments_helper.dart';
import 'package:project2_social_media/screens/Profile/baseprofile_helpers.dart';
import 'package:project2_social_media/screens/Profile/profile_otherusers_helpers.dart';
import 'package:project2_social_media/screens/Profile/profileinfohelpers.dart';
import 'package:project2_social_media/services/authentication.dart';
import 'package:project2_social_media/services/firebase_operations.dart';
import 'package:project2_social_media/utils/post_options.dart';
import 'package:project2_social_media/utils/upload_post.dart';
import 'package:provider/provider.dart';

import 'screens/SplashScreen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final ThemeData theme = ThemeData(
    fontFamily: 'Poppins',
  );
  final TextButtonThemeData textButtonThemeData = TextButtonThemeData(
    style: ButtonStyle(
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return Colors.grey.withOpacity(0.04);
          }
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return Colors.grey.withOpacity(0.50);
          }
          return null; // Defer to the widget's default.
        },
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        theme: theme.copyWith(
          textButtonTheme: textButtonThemeData,
          colorScheme: theme.colorScheme.copyWith(
            secondary: constantColors.blueColor,
          ),
          canvasColor: constantColors.whiteColor,
          scaffoldBackgroundColor: constantColors.whiteColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
          ),
        ),
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => LandingHelpers()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingService()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => HomePageHelpers()),
        ChangeNotifierProvider(create: (_) => FeedHelpers()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => PostFunctions()),
        ChangeNotifierProvider(create: (_) => PostCommentsHelper()),
        ChangeNotifierProvider(create: (_) => ProfileInfoHelpers()),
        ChangeNotifierProvider(create: (_) => BaseProfileHelpers()),
        ChangeNotifierProvider(create: (_) => FollowPageHelpers()),
        ChangeNotifierProvider(create: (_) => ProfileOtherUsersHelpers()),
      ],
    );
  }
}
