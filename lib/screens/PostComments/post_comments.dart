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
      body: SingleChildScrollView(
        child: Provider.of<PostCommentsHelper>(context, listen: false).comments(
          context,
          widget.doc,
        ),
      ),
    );
  }
}
