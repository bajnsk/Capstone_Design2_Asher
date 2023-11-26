import 'package:flutter/material.dart';
import 'package:capstone/Home/MyPage/FollowFriend/v_FollowFriendListWidget.dart';
import '../../../DataVO/model.dart';

class FollowFriendList extends StatefulWidget {
  const FollowFriendList({super.key});

  @override
  State<FollowFriendList> createState() => _FollowFriendListState();
}

class _FollowFriendListState extends State<FollowFriendList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: FollowFriendListWidget(),
    );
  }
}
