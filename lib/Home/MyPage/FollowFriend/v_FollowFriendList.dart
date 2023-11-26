import 'package:flutter/material.dart';
import 'package:capstone/Home/MyPage/FollowFriend/v_FollowFriendListWidget.dart';

class FollowFriendList extends StatefulWidget {
  const FollowFriendList({super.key});

  @override
  State<FollowFriendList> createState() => _FollowFriendListState();
}

class _FollowFriendListState extends State<FollowFriendList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FollowFriendListWidget(),
    );
  }
}
