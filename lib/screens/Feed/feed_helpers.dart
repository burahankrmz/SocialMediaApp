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
import 'package:project2_social_media/extensions/context_extension.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  List<String> followingv2 = [];
  List<String> postsId = [];
  Object? forOneUser;
  List<QueryDocumentSnapshot<Object?>> userDatav2 = [];

  int count = 0;
  QuerySnapshot<Object?>? followingPost;

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
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

  Widget feedBoydResponsive(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: context.paddingLowHorizontal,
      child: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('following')
                  .snapshots(),
              builder: (context, followingList) {
                if (followingList.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  followingv2.clear();
                  followingv2.add(FirebaseAuth.instance.currentUser!.uid);
                  for (int i = 0; i < followingList.data!.docs.length; i++) {
                    followingv2.add(followingList.data!.docs[i]['useruid']);
                  }

                  return followingv2.isNotEmpty
                      ? StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .orderBy('time', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              List<QueryDocumentSnapshot<Object?>> userData =
                                  snapshot.data!.docs;
                              List<QueryDocumentSnapshot<Object?>> userDatav2 =
                                  snapshot.data!.docs;
                              userDatav2.clear();
                              count = 0;
                              for (int x = 0; x < followingv2.length; x++) {
                                for (int y = 0; y < userData.length; y++) {
                                  followingv2[x] == userData[y]['useruid']
                                      ? userDatav2.add(userData[y])
                                      : null;
                                }
                              }
                              userDatav2.sort((a, b) => ((b['time']) as Timestamp).toDate().compareTo((a['time'] as Timestamp).toDate()));
                              return userDatav2.isNotEmpty
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: userDatav2.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1,
                                              childAspectRatio: 0.8,
                                              // crossAxisSpacing: 12,
                                              mainAxisSpacing: 10),
                                      itemBuilder: (context, index) {
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          child: Padding(
                                            padding: context
                                                .paddingHighHorizontalMediumVertical,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid !=
                                                                  userDatav2[
                                                                          index]
                                                                      [
                                                                      'useruid']
                                                              ? Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ProfileOtherUsers(userUid: userDatav2[index]['useruid'])))
                                                              : null;
                                                        },
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              userDatav2[index]
                                                                  ['userimage'],
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage:
                                                                imageProvider,
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const SizedBox(
                                                            height: 25,
                                                            width: 25,
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .blue),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            userDatav2[index]
                                                                ['username'],
                                                            style: const TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            PostFunctions()
                                                                .showTimeAgo(
                                                                    userDatav2[
                                                                            index]
                                                                        [
                                                                        'time']),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 10.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid ==
                                                              userDatav2[index]
                                                                  ['useruid']
                                                          ? IconButton(
                                                              onPressed: () {
                                                                Provider.of<PostFunctions>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .showPostOptions(
                                                                        context,
                                                                        userDatav2[
                                                                            index]);
                                                              },
                                                              icon: const Icon(
                                                                  Icons
                                                                      .more_horiz),
                                                            )
                                                          : SizedBox(
                                                              width: context
                                                                  .dynamicWidth(
                                                                      0.1),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: context
                                                      .dynamicHeight(0.02),
                                                ),
                                                Expanded(
                                                  flex: 7,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          userDatav2[index]
                                                              ['postimage'],
                                                      width: context
                                                          .dynamicWidth(0.9),
                                                      fit: BoxFit.fitWidth,
                                                      placeholder:
                                                          (context, url) {
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: context
                                                      .dynamicHeight(0.02),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: context
                                                        .paddingLowVertical,
                                                    child: Text(
                                                      userDatav2[index]
                                                          ['caption'],
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      StreamBuilder<
                                                              QuerySnapshot>(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'posts')
                                                              .doc(userDatav2[
                                                                      index]
                                                                  ['caption'])
                                                              .collection(
                                                                  'likes')
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshotLikes) {
                                                            if (snapshotLikes
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return const CircularProgressIndicator();
                                                            } else {
                                                              for (var snapshotfind
                                                                  in snapshotLikes
                                                                      .data!
                                                                      .docs) {
                                                                if (snapshotfind[
                                                                        'useruid'] ==
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid) {
                                                                  return LikeButton(
                                                                    size: 20,
                                                                    onTap: (bool
                                                                        isLiked) {
                                                                      Provider.of<PostFunctions>(context, listen: false).removeLike(
                                                                          context,
                                                                          snapshot.data!.docs[index]
                                                                              [
                                                                              'caption'],
                                                                          FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .uid);
                                                                      return PostFunctions()
                                                                          .onLikeButtonTapped(
                                                                              isLiked);
                                                                    },
                                                                    likeCountPadding:
                                                                        context
                                                                            .paddingOnlyLeftLow,
                                                                    likeCount: snapshotLikes
                                                                        .data!
                                                                        .docs
                                                                        .length,
                                                                    likeBuilder:
                                                                        (_) {
                                                                      return const Icon(
                                                                          FontAwesomeIcons
                                                                              .solidHeart,
                                                                          size:
                                                                              20.0,
                                                                          color:
                                                                              Colors.red);
                                                                    },
                                                                  );
                                                                }
                                                              }
                                                              return LikeButton(
                                                                onTap: (bool
                                                                    isLiked) {
                                                                  Provider.of<PostFunctions>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .addLike(
                                                                          context,
                                                                          snapshot.data!.docs[index]
                                                                              [
                                                                              'caption'],
                                                                          FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .uid)
                                                                      .whenComplete(
                                                                          () {
                                                                    //isLiked = true;
                                                                  });
                                                                  return PostFunctions()
                                                                      .onLikeButtonTapped(
                                                                          isLiked);
                                                                },
                                                                likeCountPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                size: 20.0,
                                                                likeCount:
                                                                    snapshotLikes
                                                                        .data!
                                                                        .docs
                                                                        .length,
                                                                //isLiked: isLiked,
                                                              );
                                                            }
                                                          }),
                                                      MaterialButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  child: PostComments(
                                                                      doc: userDatav2[
                                                                          index]),
                                                                  type: PageTransitionType
                                                                      .bottomToTop));
                                                        },
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              EvaIcons
                                                                  .messageSquareOutline,
                                                              size: 20.0,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            StreamBuilder<
                                                                QuerySnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'posts')
                                                                  .doc(userDatav2[
                                                                          index]
                                                                      [
                                                                      'caption'])
                                                                  .collection(
                                                                      'comments')
                                                                  .orderBy(
                                                                      'time')
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return const Center(
                                                                      child:
                                                                          CircularProgressIndicator());
                                                                } else {
                                                                  return Padding(
                                                                    padding: context
                                                                        .paddingOnlyLeftLow,
                                                                    child: Text(snapshot
                                                                        .data!
                                                                        .docs
                                                                        .length
                                                                        .toString()),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Text(
                                          'There is no posts from your following users.'),
                                    );
                            }
                          })
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('You are not following anyone'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Please follow some people'),
                            ],
                          ),
                        );
                }
              })
        ],
      ),
    ));
  }

  Widget feedBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('following')
            .snapshots(),
        builder: (context, followingList) {
          if (followingList.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            followingv2.clear();
            for (int i = 0; i < followingList.data!.docs.length; i++) {
              followingv2.add(followingList.data!.docs[i]['useruid']);
            }
            return followingv2.isNotEmpty
                ? StreamBuilder<QuerySnapshot>(
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
                        List<QueryDocumentSnapshot<Object?>> userData =
                            snapshot.data!.docs;
                        List<QueryDocumentSnapshot<Object?>> userDatav2 =
                            snapshot.data!.docs;
                        userDatav2.clear();
                        count = 0;
                        for (int x = 0; x < followingv2.length; x++) {
                          for (int y = 0; y < userData.length; y++) {
                            followingv2[x] == userData[y]['useruid']
                                ? userDatav2.add(userData[y])
                                : null;
                          }
                        }
                        return userDatav2.isNotEmpty
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: userDatav2.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                                    userUid: userDatav2[
                                                                            index]
                                                                        [
                                                                        'useruid'])));
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                      userDatav2[index]
                                                          ['userimage'],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                userDatav2[index]['username'],
                                                style: const TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                PostFunctions().showTimeAgo(
                                                    userDatav2[index]['time']),
                                                style: const TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                              trailing: IconButton(
                                                onPressed: () {
                                                  Provider.of<PostFunctions>(
                                                          context,
                                                          listen: false)
                                                      .showPostOptions(context,
                                                          userDatav2[index]);
                                                },
                                                icon: const Icon(
                                                    Icons.more_horiz),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 20.0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: CachedNetworkImage(
                                                  imageUrl: userDatav2[index]
                                                      ['postimage'],
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.5,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                              userDatav2[index]['caption'],
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
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('posts')
                                                      .doc(snapshot
                                                              .data!.docs[index]
                                                          ['caption'])
                                                      .collection('likes')
                                                      .snapshots(),
                                                  builder:
                                                      (context, snapshotLikes) {
                                                    if (snapshotLikes
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    } else {
                                                      for (var snapshotfind
                                                          in snapshotLikes
                                                              .data!.docs) {
                                                        if (snapshotfind[
                                                                'useruid'] ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid) {
                                                          return LikeButton(
                                                            onTap:
                                                                (bool isLiked) {
                                                              Provider.of<PostFunctions>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .removeLike(
                                                                      context,
                                                                      snapshot.data!
                                                                              .docs[index]
                                                                          [
                                                                          'caption'],
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid);
                                                              return PostFunctions()
                                                                  .onLikeButtonTapped(
                                                                      isLiked);
                                                            },
                                                            likeCountPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            likeCount:
                                                                snapshotLikes
                                                                    .data!
                                                                    .docs
                                                                    .length,
                                                            likeBuilder: (_) {
                                                              return const Icon(
                                                                  FontAwesomeIcons
                                                                      .solidHeart,
                                                                  size: 20.0,
                                                                  color: Colors
                                                                      .red);
                                                            },
                                                          );
                                                        }
                                                      }
                                                      return LikeButton(
                                                        onTap: (bool isLiked) {
                                                          Provider.of<PostFunctions>(
                                                                  context,
                                                                  listen: false)
                                                              .addLike(
                                                                  context,
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'caption'],
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)
                                                              .whenComplete(() {
                                                            //isLiked = true;
                                                          });
                                                          return PostFunctions()
                                                              .onLikeButtonTapped(
                                                                  isLiked);
                                                        },
                                                        likeCountPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        size: 20.0,
                                                        likeCount: snapshotLikes
                                                            .data!.docs.length,
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
                                                              doc: snapshot
                                                                  .data!
                                                                  .docs[index]),
                                                          type:
                                                              PageTransitionType
                                                                  .bottomToTop));
                                                },
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      EvaIcons
                                                          .messageSquareOutline,
                                                      size: 20.0,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('posts')
                                                          .doc(snapshot.data!
                                                                  .docs[index]
                                                              ['caption'])
                                                          .collection(
                                                              'comments')
                                                          .orderBy('time')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        } else {
                                                          return Text(snapshot
                                                              .data!.docs.length
                                                              .toString());
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                            : const Center(
                                child: Text(
                                    'There is no posts from your following users.'),
                              );
                      }
                    })
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('You are not following anyone'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Please follow some people'),
                      ],
                    ),
                  );
          }
        });
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
