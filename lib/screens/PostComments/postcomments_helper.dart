import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/utils/post_options.dart';
import 'package:provider/provider.dart';

class PostCommentsHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final TextEditingController commentController = TextEditingController();
  AppBar appBar(BuildContext context, QueryDocumentSnapshot<Object?> doc) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: SizedBox(
        //color: Colors.orange,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(
                  doc['userimage'],
                ),
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['username'],
                  style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const Text(
                  '5 min',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  postBody(BuildContext context, QueryDocumentSnapshot<Object?> doc) {
    return Material(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0)),
      //color: Colors.black,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2.3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Material(
                color: Colors.transparent,
                elevation: 25.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: doc['postimage'],
                    height: MediaQuery.of(context).size.height / 2.6,
                    width: MediaQuery.of(context).size.width / 1.2,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  comments(BuildContext context, QueryDocumentSnapshot<Object?> doc) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.12,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Provider.of<PostCommentsHelper>(context, listen: false)
                    .postBody(context, doc),
                const SizedBox(height: 8.0),
                Material(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                    ),
                    height: MediaQuery.of(context).size.height / 2.9,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(doc['caption'])
                          .collection('comments')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          if (snapshot.data!.docs.isEmpty) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Center(
                                child: Text(
                                  'No Comments Yet.',
                                ),
                              ),
                            );
                          } else {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 15.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: CircleAvatar(
                                                radius: 20.0,
                                                backgroundImage: NetworkImage(
                                                  snapshot.data!.docs[index]
                                                      ['userimage'],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 25.0,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data!.docs[index]
                                                    ['username'],
                                                style: const TextStyle(
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.3,
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['comment'],
                                                  style: const TextStyle(
                                                    fontSize: 10.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1.0,
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        positioned(context, doc)
      ],
    );
  }

  Widget positioned(BuildContext context, QueryDocumentSnapshot<Object?> doc) {
    return Positioned(
      bottom: 0,
      child: Material(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        child: SizedBox(
          height: 90.0,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.05,
              height: 65.0,
              child: TextField(
                controller: commentController,
                maxLines: 3,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: Container(
                    width: 60.0,
                    margin: const EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      color: Colors.green,
                    ),
                    child: IconButton(
                      onPressed: () {
                        debugPrint('adding comment');
                        Provider.of<PostFunctions>(context, listen: false)
                            .addComment(context, doc['caption'],
                                commentController.text);
                        commentController.clear();
                      },
                      icon: const Icon(FontAwesomeIcons.telegramPlane,
                          color: Colors.white),
                    ),
                  ),
                  prefixIcon: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          dynamic userData = snapshot.data!.data();
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Material(
                              color: Colors.transparent,
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundImage: NetworkImage(
                                  userData!['userimage'],
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  hintText: 'Comment...',
                  labelText: 'Comment',
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
