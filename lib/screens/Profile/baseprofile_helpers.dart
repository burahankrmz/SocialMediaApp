import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/main.dart';
import 'package:project2_social_media/screens/PostComments/post_comments.dart';
import 'package:project2_social_media/screens/Profile/profileinfohelpers.dart';
import 'package:project2_social_media/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class BaseProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  dynamic userData;
  dynamic userNullCheckData;

  Widget infoContainer(
    BuildContext context,
    Object? data,
  ) {
    userData = data;
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
                    buildUserCircleAvatar(),
                    buildUserNameText(),
                    buildUserEmailText(),
                  ],
                ),
                buildPostTextButton(context),
                buildFollowersTextButton(context),
                buildFollowingTextButton(context),
              ],
            ),
            buildProfileButtons(context),
            buildDivider(),
          ],
        ),
      ),
    );
  }

  Widget posts(
    BuildContext context,
    Object? data,
  ) {
    userData = data;
    debugPrint(userData['useruid']);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userData['useruid'])
          .collection('posts')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(child: CircularProgressIndicator());
        } else {
          return SliverStickyHeader(
            header: buildMyPostsHeader(),
            sliver: snapshot.data!.docs.isEmpty
                ? buildEmptyPosts(context)
                : buildUserPosts(snapshot),
          );
        }
      },
    );
  }

  SliverGrid buildUserPosts(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return SliverGrid(
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
                  type: PageTransitionType.fade,
                ),
              );
            },
            child: Container(
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
    );
  }

  SliverToBoxAdapter buildEmptyPosts(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: Text('There Is No Post Yet',style: TextStyle(fontSize: 20.0),),
        ),
      ),
    );
  }

  Material buildMyPostsHeader() {
    return Material(
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
    );
  }

  Divider buildDivider() {
    return const Divider(
      thickness: 4.0,
    );
  }

  Padding buildProfileButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: userData['useruid'] == FirebaseAuth.instance.currentUser!.uid
          ? buildEditProfileButton(context)
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildFollowButton(context, userData),
                MaterialButton(
                    color: constantColors.whiteColor,
                    elevation: 3.0,
                    child: const Text(
                      'Message',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {})
              ],
            ),
    );
  }

  Text buildUserEmailText() {
    return const Text(
      'Samsun',
    );
  }

  Text buildUserNameText() => Text(userData['username']);

  Padding buildUserCircleAvatar() {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0, bottom: 5.0, left: 20.0),
      child: CachedNetworkImage(
        imageUrl: userData['userimage'],
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 35.0,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => const SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  TextButton buildPostTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      onLongPress: () {},
      style: MyApp().textButtonThemeData.style,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Provider.of<ProfileInfoHelpers>(context, listen: false)
              .postText(context, userData['useruid'], 'posts'),
          const Text(
            'Posts',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  TextButton buildFollowersTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      onLongPress: () {},
      style: MyApp().textButtonThemeData.style,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Provider.of<ProfileInfoHelpers>(context, listen: false)
              .postText(context, userData['useruid'], 'followers'),
          const Text(
            'Followers',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  TextButton buildFollowingTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      onLongPress: () {},
      style: MyApp().textButtonThemeData.style,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Provider.of<ProfileInfoHelpers>(context, listen: false)
              .postText(context, userData['useruid'], 'following'),
          const Text(
            'Following',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  MaterialButton buildEditProfileButton(BuildContext context) {
    return MaterialButton(
      color: constantColors.whiteColor,
      elevation: 3.0,
      minWidth: MediaQuery.of(context).size.width / 1.2,
      child: const Text(
        'Edit Profile',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: () {},
    );
  }

  MaterialButton buildFollowButton(
    BuildContext context,
    userData,
  ) {
    return MaterialButton(
        color: constantColors.whiteColor,
        elevation: 3.0,
        child: const Text(
          'Follow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Provider.of<FirebaseOperations>(context, listen: false).followUser(
            userData['useruid'],
            FirebaseAuth.instance.currentUser!.uid,
            {
              'username':
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .getInitUserName,
              'userimage':
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .getInitUserImage,
              'useremail':
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .getInitUserEmail,
              'useruid': FirebaseAuth.instance.currentUser!.uid,
              'time': Timestamp.now()
            },
            FirebaseAuth.instance.currentUser!.uid,
            userData['useruid'],
            {
              'username': userData['username'],
              'userimage': userData['userimage'],
              'useremail': userData['useremail'],
              'useruid': userData['useruid'],
              'time': Timestamp.now()
            },
          );
        });
  }
}
