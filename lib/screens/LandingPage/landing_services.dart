import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/HomePage/homepage.dart';
import 'package:project2_social_media/screens/LandingPage/landing_utils.dart';
import 'package:project2_social_media/services/authentication.dart';
import 'package:project2_social_media/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class LandingService with ChangeNotifier {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  bool pwSecure = true;

  ConstantColors constantColors = ConstantColors();
  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
                  Map<String, dynamic> data =
                      documentSnapshot.data()! as Map<String, dynamic>;
                  return ListTile(
                    trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.trashAlt,
                          color: constantColors.redColor,
                        )),
                    leading: CircleAvatar(
                      backgroundColor: constantColors.transperant,
                      backgroundImage: NetworkImage(
                        data['userimage'],
                      ), //documentSnapshot.data()['userimage']
                    ),
                    subtitle: Text(
                      data['useremail'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constantColors.greenColor),
                    ),
                    title: Text(
                      data['username'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constantColors.greenColor),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ));
  }

  logInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        validator: (value) => EmailValidator.validate(value!)
                            ? null
                            : "Please enter a valid email",
                        controller: userEmailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Email...',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      obscureText: pwSecure,
                      controller: userPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Enter Password...',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (userEmailController.text.isNotEmpty &&
                          userPasswordController.text.isNotEmpty) {
                        if (EmailValidator.validate(userEmailController.text)) {
                          Provider.of<Authentication>(context, listen: false)
                              .logIntoAccount(userEmailController.text,
                                  userPasswordController.text)
                              .whenComplete(() {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .initUserData(context)
                                .whenComplete(() {
                              Timer(const Duration(seconds: 2), () {
                                userEmailController.clear();
                                userPasswordController.clear();
                              });
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageTransition(
                                      child: const HomePage(),
                                      type: PageTransitionType.bottomToTop),
                                  (route) => false);
                            });
                          });
                        } else {
                          warningText(context, 'Wrong Email Format');
                        }
                      } else {
                        warningText(context, 'Fill All The Data');
                      }
                    },
                    backgroundColor: constantColors.blueColor,
                    child: Icon(
                      FontAwesomeIcons.check,
                      color: constantColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150.0),
                      child: Divider(
                        thickness: 4.0,
                        color: constantColors.whiteColor,
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: FileImage(
                          Provider.of<LandingUtils>(context).getUserAvatar),
                      backgroundColor: constantColors.redColor,
                      radius: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter Name...',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: userEmailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Email...',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: userPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Enter Password...',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          if (userEmailController.text.isNotEmpty &&
                              userPasswordController.text.isNotEmpty) {
                            Provider.of<Authentication>(context, listen: false)
                                .createAccount(userEmailController.text,
                                    userPasswordController.text)
                                .whenComplete(() {
                              debugPrint('Creating Firebase Account');
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .createUserCollection(context, {
                                '': userPasswordController.text,
                                'useruid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                'useremail': userEmailController.text,
                                'username': userNameController.text,
                                'userimage': Provider.of<LandingUtils>(context,
                                        listen: false)
                                    .getUserAvatarUrl,
                              });
                            }).whenComplete(() {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: const HomePage(),
                                      type: PageTransitionType.bottomToTop));
                            });
                            debugPrint('account created');
                          } else {
                            warningText(context, 'Fill all the data');
                          }
                        },
                        backgroundColor: constantColors.redColor,
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  radius: 60.0,
                  backgroundColor: constantColors.transperant,
                  backgroundImage: FileImage(
                    Provider.of<LandingUtils>(context, listen: false)
                        .userAvatar!,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Provider.of<LandingUtils>(context, listen: false)
                            .pickUserAvatar(context, ImageSource.camera);
                      },
                      child: Text(
                        'Reselect',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: constantColors.whiteColor,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .uploadUserAvatar(context)
                            .whenComplete(() {
                          signInSheet(context);
                        });
                      },
                      child: Text(
                        'Confirm Image',
                        style: TextStyle(
                          color: constantColors.blueColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: constantColors.whiteColor,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  showUserAvatarv2(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Provider.of<LandingUtils>(context, listen: true).userAvatar !=
                        null
                    ? CircleAvatar(
                        radius: 60.0,
                        backgroundColor: constantColors.transperant,
                        backgroundImage: FileImage(
                          Provider.of<LandingUtils>(context, listen: false)
                              .getUserAvatar,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.photo_size_select_actual_rounded,
                          color: Colors.white,
                          size: 65.0,
                        ),
                      ),
                Provider.of<LandingUtils>(context, listen: true).userAvatar !=
                        null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              Provider.of<LandingUtils>(context, listen: false)
                                  .pickUserAvatar(context, ImageSource.camera);
                            },
                            child: Text(
                              'Reselect',
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: constantColors.whiteColor,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .uploadUserAvatar(context)
                                  .whenComplete(() {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              'Confirm Image',
                              style: TextStyle(
                                color: constantColors.blueColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: constantColors.whiteColor,
                              ),
                            ),
                          )
                        ],
                      )
                    : MaterialButton(
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .pickUserAvatar(context, ImageSource.camera);
                        },
                        child: Text(
                          'Please Choose A Profile Picture',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: constantColors.whiteColor,
                          ),
                        ),
                      ),
              ],
            ),
          );
        });
  }
}
