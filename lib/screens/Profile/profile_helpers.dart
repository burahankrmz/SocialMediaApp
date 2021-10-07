import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/main.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget infoContainer(BuildContext context, DocumentSnapshot snapshot) {
    return SliverToBoxAdapter(
      child: Container(
        //color: constantColors.darkColor,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0, bottom: 5.0),
                      child: CircleAvatar(
                        radius: 35.0,
                        backgroundImage: NetworkImage(snapshot['userimage']),
                      ),
                    ),
                    Text(snapshot['username']),
                    const Text('SAMSUN'),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  onLongPress: () {},
                  style: MyApp().textButtonThemeData.style,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '4',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        'Posts',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  onLongPress: () {},
                  style: MyApp().textButtonThemeData.style,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '155',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        'Followers',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  onLongPress: () {},
                  style: MyApp().textButtonThemeData.style,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '170',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        'Following',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                  color: constantColors.whiteColor,
                  elevation: 3.0,
                  minWidth: MediaQuery.of(context).size.width / 1.2,
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {}),
            ),
            const Divider(
              thickness: 4.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget myPosts(BuildContext context, DocumentSnapshot snapshot) {
    return SliverStickyHeader(
      header: Material(
        elevation: 4.0,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            bottom: 5.0,
          ),
          child: const Text(
            'My Posts',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: 1.0,
          crossAxisCount: 3,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(snapshot['userimage']),
                ),
              ),
            );
          },
          childCount: 20,
        ),
      ),
    );
  }
}
