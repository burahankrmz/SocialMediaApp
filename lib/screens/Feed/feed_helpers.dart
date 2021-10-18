import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:like_button/like_button.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
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
                Timestamp timestamp = snapshot.data!.docs[index]['time'];
                var time = readTimestamp(timestamp.millisecondsSinceEpoch);

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    //height: MediaQuery.of(context).size.height,
                    //width: MediaQuery.of(context).size.width,
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
                              elevation: 20.0,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]['userimage'],
                                ),
                              ),
                            ),
                            title: Text(
                              snapshot.data!.docs[index]['username'],
                              style: const TextStyle(
                                  fontSize: 13.0, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              time,
                              style: const TextStyle(
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
                            color: Colors.transparent,
                            elevation: 20.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!.docs[index]
                                    ['postimage'],
                                height: MediaQuery.of(context).size.height / 2,
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
                            const LikeButton(
                              likeCountPadding: EdgeInsets.only(left: 8.0),
                              size: 20.0,
                              likeCount: 2515,
                            ),
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
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14.0),
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

  Widget feedBoydV3(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return CustomScrollView(
            slivers: [
              myPosts(context, snapshot),
            ],
          );
        }
      },
    );
  }

  SliverGrid myPosts(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 0.2,
        crossAxisSpacing: 10.0,
        childAspectRatio: 0.9,
        crossAxisCount: 1,
      ),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Card(
          margin: const EdgeInsets.only(
            top: 18.0,
            right: 18.0,
            left: 18.0,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  leading: Material(
                    color: Colors.transparent,
                    elevation: 20.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data!.docs[index]['userimage'],
                      ),
                    ),
                  ),
                  title: Text(
                    snapshot.data!.docs[index]['username'],
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
                  color: Colors.transparent,
                  elevation: 20.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data!.docs[index]['postimage'],
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                          style: TextStyle(color: Colors.grey, fontSize: 14.0),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }, childCount: snapshot.data!.docs.length),
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
