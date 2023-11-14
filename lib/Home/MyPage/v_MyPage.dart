import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'c_MyPageController.dart';
import 'v_MyPageWidget.dart';
import 'package:capstone/DataVO/model.dart';
import 'package:logger/logger.dart';
import 'c_MyPageController.dart';

class MyPageView extends StatefulWidget {
  MyPageView({Key? key}) : super(key: key);

  @override
  State<MyPageView> createState() => MyPageWidgetState();
}

class MyPageWidgetState extends State<MyPageView> {
  late List<FeedDataVO> MyFeedsList = MyController.myFeedsList;
  late List<FeedDataVO> iLikeFeedsList = MyController.myFeedsList;
  late int index = 0; // index를 초기화

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      MyController.myFeedsList = await MyController.getMyFeedsList();
      MyFeedsList = await MyController.myFeedsList;
      logger.d(MyFeedsList);
      MyController.iLikeFeedsList = await MyController.getMyFeedsList();
      logger.d(iLikeFeedsList);
      setState(() {});
    });
    // Initially, show all items
  }

  @override
  Widget build(BuildContext context) {
    FeedDataVO feedData = widget.MyFeedsList[index];
    return MyPageWidget(
      MyFeedsList: MyFeedsList,
      feedData: feedData,
      index: index,
    );
  }
}

