import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/main.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:project2_social_media/screens/PostComments/post_comments.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  late DocumentSnapshot userData;

  Widget infoContainerv2(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            userData = snapshot.data!;
            return SliverToBoxAdapter(
              child: Container(
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
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 14.0, bottom: 5.0),
                              child: CircleAvatar(
                                radius: 35.0,
                                backgroundImage:
                                    NetworkImage(userData['userimage']),
                              ),
                            ),
                            Text(userData['username']),
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
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
        });
  }

  Widget infoContainer(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return SliverToBoxAdapter(
      child: Container(
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0, bottom: 5.0),
                      child: CircleAvatar(
                        radius: 35.0,
                        backgroundImage:
                            NetworkImage(snapshot.data!.docs[0]['userimage']),
                      ),
                    ),
                    Text(snapshot.data!.docs[0]['username']),
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

  Widget myPosts(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
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
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: PostComments(doc: snapshot.data!.docs[index]),
                        type: PageTransitionType.fade));
              },
              child: Container(
                //margin: const EdgeInsets.only(top: 8.0),
                //padding: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        snapshot.data!.docs[index]['postimage']),
                  ),
                ),
              ),
            );
          },
          childCount: snapshot.data!.docs.length,
        ),
      ),
    );
  }
}
