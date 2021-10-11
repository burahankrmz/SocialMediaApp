import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:like_button/like_button.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/utils/upload_post.dart';
import 'package:provider/provider.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  late DocumentSnapshot userData;

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.menu_sharp,
          color: Colors.black,
        ),
      ),
      title: RichText(
        text: TextSpan(
            text: 'Social ',
            style: TextStyle(
                color: constantColors.darkColor,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
            children: <TextSpan>[
              TextSpan(
                text: 'Media',
                style: TextStyle(
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0),
              ),
            ]),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<UploadPost>(context, listen: false)
                .takeImage(context);
          },
          icon: const Icon(
            Icons.add_a_photo,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget feedBodyV2(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          userData = snapshot.data!;
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                myPosts(context, userData),
              ],
            ),
          );
        }
      },
    );
  }

  Widget myPosts(BuildContext context, DocumentSnapshot snapshot) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 0.2,
        crossAxisSpacing: 10.0,
        childAspectRatio: 0.9,
        crossAxisCount: 1,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.only(
              top: 18.0,
              right: 18.0,
              left: 18.0,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    //tileColor: Colors.red,
                    leading: Material(
                      color: Colors.transparent,
                      elevation: 20.0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot['userimage'],
                        ),
                        //radius: 30.0,
                      ),
                    ),
                    title: Text(
                      snapshot['username'],
                      style: const TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      '5 min',
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Material(
                    elevation: 15.0,
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      height: 270.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            snapshot['userimage'],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 14.0,
                    ),
                    const LikeButton(
                      likeCountPadding: EdgeInsets.only(left: 8.0),
                      size: 20.0,
                      likeCount: 2515,
                    ),
                    /*
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.heart,
                        size: 20.0,
                      ),
                    ),
                    const Text(
                      '2,515',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.0),
                    ),
                    */
                    const SizedBox(
                      width: 10.0,
                    ),
                    MaterialButton(
                      onPressed: () {},
                      child: Row(
                        children: const [
                          Icon(
                            EvaIcons.messageSquareOutline,
                            size: 20.0,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '350',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
        childCount: 10,
      ),
    );
  }
}
