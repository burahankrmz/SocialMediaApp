import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/extensions/context_extension.dart';
import 'package:project2_social_media/screens/HomePage/homepage.dart';
import 'package:project2_social_media/screens/LandingPage/landing_utils.dart';
import 'package:project2_social_media/services/authentication.dart';
import 'package:project2_social_media/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextStyle appBarTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20.0);
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  bool pwSecure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: context.paddingHighHorizontal,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildRegisterBar(),
                buildUserImagePick(),
                buildDivider(),
                buildForm(),
                buildDivider(),
                buildAlreadyAccountText(),
                buildLoginTextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildLoginTextButton() {
    return SizedBox(
      height: context.dynamicHeight(0.07),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Log in',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  SizedBox buildAlreadyAccountText() {
    return SizedBox(
      height: context.dynamicHeight(0.04),
      child: const Text(
        'Already have an account?',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  SizedBox buildUserImagePick() {
    return SizedBox(
      child: Provider.of<LandingUtils>(context).userAvatar != null
          ? CircleAvatar(
              backgroundImage: FileImage(
                  Provider.of<LandingUtils>(context, listen: false)
                      .getUserAvatar),
              backgroundColor: constantColors.redColor,
              radius: 60.0,
            )
          : GestureDetector(
              onTap: () {
                Provider.of<LandingUtils>(context, listen: false)
                    .selectAvatarOptionsSheet(context);
              },
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.photo_size_select_actual_rounded,
                      color: Colors.white,
                      size: 65.0,
                    ),
                  ),
                  Text(
                    'Please Select Profile Image',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
    );
  }

  Widget buildForm() {
    return SizedBox(
      height: context.dynamicHeight(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Name',
            style: appBarTextStyle.copyWith(fontSize: 15),
          ),
          TextField(
            controller: userNameController,
            decoration: InputDecoration(
              contentPadding: context.paddingAllLow,
              hintText: 'Enter Name...',
              hintStyle: TextStyle(
                  color: constantColors.greyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            style: TextStyle(color: constantColors.darkColor, fontSize: 15.0),
          ),
          Text(
            'Email',
            style: appBarTextStyle.copyWith(fontSize: 15),
          ),
          TextFormField(
            validator: (value) => EmailValidator.validate(value!)
                ? null
                : "Please enter a valid email",
            controller: userEmailController,
            decoration: InputDecoration(
              contentPadding: context.paddingAllLow,
              hintText: 'Enter Email...',
              hintStyle: TextStyle(
                  color: constantColors.greyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            style: TextStyle(color: constantColors.darkColor, fontSize: 15.0),
          ),
          Text(
            'Password',
            style: appBarTextStyle.copyWith(fontSize: 15),
          ),
          TextField(
            obscureText: pwSecure,
            controller: userPasswordController,
            decoration: InputDecoration(
              contentPadding: context.paddingAllLow,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    pwSecure = !pwSecure;
                  });
                },
                icon: const Icon(Icons.remove_red_eye),
              ),
              hintText: 'Enter Password...',
              hintStyle: TextStyle(
                  color: constantColors.greyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            style: TextStyle(color: constantColors.darkColor, fontSize: 18.0),
          ),
          SizedBox(
            height: context.dynamicHeight(0.06),
            width: context.dynamicHeight(1),
            child: MaterialButton(
              onPressed: () {
                if (userEmailController.text.isNotEmpty &&
                    userPasswordController.text.isNotEmpty) {
                  Provider.of<Authentication>(context, listen: false)
                      .createAccount(
                          userEmailController.text, userPasswordController.text)
                      .whenComplete(() {
                    debugPrint('Creating Firebase Account');
                    debugPrint(Provider.of<LandingUtils>(context, listen: false)
                        .userAvatarUrl);
                    debugPrint(userPasswordController.text);
                    debugPrint(userNameController.text);
                    debugPrint(userEmailController.text);
                    debugPrint(
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid);

                    Provider.of<FirebaseOperations>(context, listen: false)
                        .createUserCollection(context, {
                      'useruid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'useremail': userEmailController.text,
                      'username': userNameController.text,
                      'userimage':
                          Provider.of<LandingUtils>(context, listen: false)
                              .userAvatarUrl,
                    });
                  }).whenComplete(() {
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .initUserData(context)
                        .whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: const HomePage(),
                              type: PageTransitionType.bottomToTop));
                    });
                  });
                } else {
                  warningText(context, 'Fill all the data');
                }
              },
              child: const Text(
                'Sign up',
                style: TextStyle(color: Colors.white),
              ),
              color: constantColors.blueColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return SizedBox(
      height: context.dynamicHeight(0.05),
      child: const Divider(
        thickness: 2,
      ),
    );
  }

  SizedBox buildGoogleLoginButton() {
    return SizedBox(
      height: context.dynamicHeight(0.05),
      child: OutlinedButton(
        onPressed: () {
          Provider.of<Authentication>(context, listen: false)
              .signInWithGoogle()
              .whenComplete(() {
            Provider.of<FirebaseOperations>(context, listen: false)
                .initUserData(context)
                .whenComplete(() {
              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                      child: const HomePage(),
                      type: PageTransitionType.bottomToTop),
                  (route) => false);
            });
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'G   ',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 20),
            ),
            Text(
              'Log in with Google',
              style: appBarTextStyle.copyWith(fontSize: 16),
            ),
          ],
        ),
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0))),
      ),
    );
  }

  Widget buildRegisterBar() {
    return SizedBox(
      height: context.dynamicHeight(0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sign up',
            style: appBarTextStyle,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    25.0,
                  ),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: constantColors.darkColor,
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          );
        });
  }
}
