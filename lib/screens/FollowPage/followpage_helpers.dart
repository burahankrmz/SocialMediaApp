import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:project2_social_media/screens/Profile/baseprofile.dart';
import 'package:project2_social_media/screens/Profile/profile_otherusers.dart';

class FollowPageHelpers with ChangeNotifier {
  StreamBuilder<QuerySnapshot<Object?>> buildFollowList(
      userData, String collectionName) {
    dynamic userFollowingData;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userData['useruid'])
          .collection(collectionName)
          .snapshots(),
      builder: (builder, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          userFollowingData = snapshot.data!.docs;
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  FirebaseAuth.instance.currentUser!.uid !=
                          snapshot.data!.docs[index]['useruid']
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileOtherUsers(
                                  userUid: snapshot.data!.docs[index]
                                      ['useruid'])))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BaseProfile()));
                },
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    userFollowingData[index]['userimage'],
                  ),
                ),
                title: Text(userFollowingData[index]['username']),
                subtitle: Text(userFollowingData[index]['useremail']),
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        }
      },
    );
  }
}
