import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/PostComments/post_comments.dart';
import 'package:project2_social_media/screens/Profile/profile_otherusers.dart';
import 'package:project2_social_media/utils/post_options.dart';
import 'package:project2_social_media/utils/upload_post.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

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
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<UploadPost>(context, listen: false).takeImage(context);
          },
          icon: const Icon(
            Icons.add_a_photo,
            color: Colors.black,
          ),
        ),
      ],
    );
  }





  Widget feedBodyV4(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ListTile(
                            leading: Material(
                              color: Colors.transparent,
                              elevation: 15.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileOtherUsers(
                                                  userUid:
                                                      snapshot.data!.docs[index]
                                                          ['useruid'])));
                                },
                                child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data!.docs[index]['userimage'],
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              snapshot.data!.docs[index]['username'],
                              style: const TextStyle(
                                  fontSize: 13.0, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              PostFunctions().showTimeAgo(
                                  snapshot.data!.docs[index]['time']),
                              style: const TextStyle(
                                fontSize: 10.0,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showPostOptions(context);
                              },
                              icon: const Icon(Icons.more_horiz),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 20.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!.docs[index]
                                    ['postimage'],
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
                                width: MediaQuery.of(context).size.width,
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
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            snapshot.data!.docs[index]['caption'],
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 14.0,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(snapshot.data!.docs[index]['caption'])
                                    .collection('likes')
                                    .snapshots(),
                                builder: (context, snapshotLikes) {
                                  if (snapshotLikes.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    for (var snapshotfind
                                        in snapshotLikes.data!.docs) {
                                      if (snapshotfind['useruid'] ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid) {
                                        return LikeButton(
                                          onTap: (bool isLiked) {
                                            Provider.of<PostFunctions>(context,
                                                    listen: false)
                                                .removeLike(
                                                    context,
                                                    snapshot.data!.docs[index]
                                                        ['caption'],
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid);
                                            return PostFunctions()
                                                .onLikeButtonTapped(isLiked);
                                          },
                                          likeCountPadding:
                                              const EdgeInsets.only(left: 8.0),
                                          likeCount:
                                              snapshotLikes.data!.docs.length,
                                          likeBuilder: (_) {
                                            return const Icon(
                                                FontAwesomeIcons.solidHeart,
                                                size: 20.0,
                                                color: Colors.red);
                                          },
                                        );
                                      }
                                    }
                                    return LikeButton(
                                      onTap: (bool isLiked) {
                                        Provider.of<PostFunctions>(context,
                                                listen: false)
                                            .addLike(
                                                context,
                                                snapshot.data!.docs[index]
                                                    ['caption'],
                                                FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .whenComplete(() {
                                          //isLiked = true;
                                        });
                                        return PostFunctions()
                                            .onLikeButtonTapped(isLiked);
                                      },
                                      likeCountPadding:
                                          const EdgeInsets.only(left: 8.0),
                                      size: 20.0,
                                      likeCount:
                                          snapshotLikes.data!.docs.length,
                                      //isLiked: isLiked,
                                    );
                                  }
                                }),
                            const SizedBox(
                              width: 10.0,
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: PostComments(
                                            doc: snapshot.data!.docs[index]),
                                        type: PageTransitionType.bottomToTop));
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    EvaIcons.messageSquareOutline,
                                    size: 20.0,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(snapshot.data!.docs[index]
                                            ['caption'])
                                        .collection('comments')
                                        .orderBy('time')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        return Text(snapshot.data!.docs.length
                                            .toString());
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        }
      },
    );
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
}
