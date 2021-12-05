import 'package:flutter/material.dart';
import 'package:project2_social_media/screens/FollowPage/followpage_helpers.dart';
import 'package:project2_social_media/screens/Profile/profileinfohelpers.dart';
import 'package:provider/provider.dart';

class FollowPage extends StatefulWidget {
  final dynamic userData;
  final int initialPageIndex;
  const FollowPage({Key? key, this.userData, required this.initialPageIndex})
      : super(key: key);

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  dynamic userFollowingData;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialPageIndex,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              title: Text(
                widget.userData['username'],
                style: const TextStyle(color: Colors.black),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: TabBar(
                    labelColor: Colors.black,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    unselectedLabelColor: Colors.grey,
                    unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    indicatorColor: Colors.black,
                    tabs: [
                      Provider.of<ProfileInfoHelpers>(context, listen: false)
                          .followersText(context, widget.userData['useruid'],
                              'followers', ' Followers'),
                      Provider.of<ProfileInfoHelpers>(context, listen: false)
                          .followersText(context, widget.userData['useruid'],
                              'following', ' Following'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 90,
                  child: TabBarView(
                    children: [
                      Provider.of<FollowPageHelpers>(context, listen: false)
                          .buildFollowList(widget.userData, 'followers'),
                      Provider.of<FollowPageHelpers>(context, listen: false)
                          .buildFollowList(widget.userData, 'following'),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
