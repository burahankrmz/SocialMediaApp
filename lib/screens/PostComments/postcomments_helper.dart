import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:project2_social_media/constants/constantcolor.dart';

class PostCommentsHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
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
        height: MediaQuery.of(context).size.height / 2,
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
            ),
          ],
        ),
      ),
    );
  }
}
