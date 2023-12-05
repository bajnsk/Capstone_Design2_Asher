import 'package:flutter/material.dart';
import 'v_MyPageFriendListWidget.dart';

class MyPageFriendList extends StatefulWidget {
  const MyPageFriendList({super.key});

  @override
  State<MyPageFriendList> createState() => _MyPageFriendListState();
}

class _MyPageFriendListState extends State<MyPageFriendList> {
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
      body: MyPageFriendListWidget(),
    );
  }
}
