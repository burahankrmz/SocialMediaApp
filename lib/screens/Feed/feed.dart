import 'package:flutter/material.dart';
import 'package:project2_social_media/constants/constantcolor.dart';
import 'package:project2_social_media/screens/Feed/feed_helpers.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Feed extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();

  Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: Provider.of<FeedHelpers>(context, listen: false).appBar(context),
      body:
          Provider.of<FeedHelpers>(context, listen: false).feedBody(context),
    );
  }
}
