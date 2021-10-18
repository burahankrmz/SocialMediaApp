import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:project2_social_media/screens/PostComments/postcomments_helper.dart';
import 'package:provider/provider.dart';

class PostComments extends StatefulWidget {
  const PostComments({
    Key? key,
    required this.doc,
  }) : super(key: key);
  final QueryDocumentSnapshot<Object?> doc;

  @override
  _PostCommentsState createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PostCommentsHelper().appBar(context, widget.doc),
      body: Stack(
        children: [
          Column(
            children: [
              Provider.of<PostCommentsHelper>(context, listen: false)
                  .postBody(context, widget.doc),
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
                  height: MediaQuery.of(context).size.height / 3.6,
                  child: ListView.builder(
                      itemCount: 15,
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
                                        widget.doc['userimage'],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 25.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.doc['username'],
                                      style: const TextStyle(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                      child: const Text(
                                        'Looks so good that i cant control my self over this.',
                                        style: TextStyle(
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
                      }),
                  //width: 450.0,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Material(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: SizedBox(
                height: 90.0,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}