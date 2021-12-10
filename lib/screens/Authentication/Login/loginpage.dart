import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/extensions/context_extension.dart';
import 'package:project2_social_media/screens/Authentication/Register/register.dart';
import 'package:project2_social_media/screens/HomePage/homepage.dart';
import 'package:project2_social_media/services/authentication.dart';
import 'package:project2_social_media/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle appBarTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20.0);
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  late String girdimi;
  ConstantColors constantColors = ConstantColors();
  bool pwSecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: context.paddingHighHorizontal,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildLoginBar(),
                buildGoogleLoginButton(),
                buildDivider(),
                buildSocialMediaText(),
                buildForm(),
                buildDivider(),
                buildAccountText(),
                buildSignupTextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  RichText buildSocialMediaText() {
    return RichText(
      text: TextSpan(
          text: 'Social',
          style: TextStyle(
            color: constantColors.darkColor,
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
    );
  }

  SizedBox buildSignupTextButton() {
    return SizedBox(
      height: context.dynamicHeight(0.07),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
                child: const RegisterPage(),
                type: PageTransitionType.rightToLeft),
          );
        },
        child: const Text(
          'Sign up',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  SizedBox buildAccountText() {
    return SizedBox(
      height: context.dynamicHeight(0.04),
      child: const Text(
        'Dont have an account?',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Form buildForm() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SizedBox(
        height: context.dynamicHeight(0.40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
            TextFormField(
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
                onPressed: () async {
                  if (userEmailController.text.isNotEmpty &&
                      userPasswordController.text.isNotEmpty) {
                    if (EmailValidator.validate(userEmailController.text)) {
                      await Provider.of<Authentication>(context, listen: false)
                          .logIntoAccount(userEmailController.text,
                              userPasswordController.text)
                          .then((value) => girdimi = value);

                      if (girdimi == 'user-not-found') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Wrong Email User Not Found')));
                      } else if (girdimi == 'wrong-password') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Wrong Password Try Again')));
                      } else if (girdimi == 'signedin') {
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
                      }
                    } else {
                      warningText(context, 'Wrong Email Format');
                    }
                  } else {
                    warningText(context, 'Fill All The Data');
                  }
                },
                child: const Text(
                  'Log in',
                  style: TextStyle(color: Colors.white),
                ),
                color: constantColors.blueColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
              ),
            ),
          ],
        ),
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

  Widget buildLoginBar() {
    return SizedBox(
      height: context.dynamicHeight(0.15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Log in',
            style: appBarTextStyle,
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
