
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/LandingPage/landing_utils.dart';
import 'package:project2_social_media/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class LandingService with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

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
