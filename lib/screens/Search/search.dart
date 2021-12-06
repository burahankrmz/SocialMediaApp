import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2_social_media/extensions/context_extension.dart';
import 'package:project2_social_media/screens/Profile/baseprofile.dart';
import 'package:project2_social_media/screens/Profile/profile_otherusers.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: searchWidget(),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: name)
              .snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data!.docs[index];
                      return ListTile(
                        onTap: () {
                          FirebaseAuth.instance.currentUser!.uid !=
                                  data['useruid']
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileOtherUsers(
                                          userUid: data['useruid'])))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BaseProfile()));
                        },
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            data['userimage'],
                          ),
                        ),
                        title: Text(data['username']),
                        subtitle: Text(data['useremail']),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Row(
      children: [
        Padding(
          padding: context.paddingLowHorizontal,
          child: const Icon(
            Icons.search,
            color: Colors.blueGrey,
          ),
        ),
        Flexible(
          child: Padding(
            padding: context.paddingLowHorizontal,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              decoration: const InputDecoration.collapsed(
                  hintText: 'Search Your Friends...'),
            ),
          ),
        ),
      ],
    );
  }
}
