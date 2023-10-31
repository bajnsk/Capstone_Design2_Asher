import 'dart:math';

import 'package:flutter/material.dart';

class Post extends StatefulWidget {

  int number;

  Post({required this.number});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 30,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,
            child: Center(
              child: Text("유저이름/게시 날짜 및 시간"),
            ),
          ),
          Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Center(
              child: Text("사진"),
            ),
          ),
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            child: Center(
              child: Text("게시글 내용"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 30,
            width: MediaQuery.of(context).size.width,
            color: Colors.green,
            child: Center(
              child: Text("태그 내용"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            height: 30,
            width: MediaQuery.of(context).size.width,
            color: Colors.blue,
            child: Center(
              child: Text("좋아요, 댓글, 리컨텐츠 아이콘"),
            ),
          ),
        ],
      ),
    );
  }
}
