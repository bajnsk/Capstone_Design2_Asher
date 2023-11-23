import 'package:flutter/material.dart';
import '../../main.dart';
import 'c_MyPageController.dart';
import 'v_MyPageWidget.dart';
import 'package:capstone/DataVO/model.dart';

class MyPageView extends StatefulWidget {
  MyPageView({Key? key}) : super(key: key);

  @override
  State<MyPageView> createState() => MyPageWidgetState();
}

class MyPageWidgetState extends State<MyPageView> {
  late List<FeedDataVO> MyFeedsList = MyController.myFeedsList;
  late List<FeedDataVO> LikeFeedsList = MyController.iLikeFeedsList;
  late int index = 0; // index를 초기화

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      MyController.myFeedsList = await MyController.getMyFeedsList();
      MyFeedsList = await MyController.myFeedsList;
      MyController.iLikeFeedsList = await MyController.getiLikeFeedsList();
      LikeFeedsList = await MyController.iLikeFeedsList;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MyFeedsList.isEmpty || index < 0 || index >= MyFeedsList.length) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          // 원하는 색상으로 변경
          strokeWidth: 4, // 선의 두께 조절
        ),
      );
    }

    FeedDataVO feedData = MyFeedsList[index]; // 수정된 부분
    return MyPageWidget(
      myFeedsList: MyFeedsList,
      likeFeedsList: LikeFeedsList,
      feedData: feedData,
      index: index,
    );
  }
}
