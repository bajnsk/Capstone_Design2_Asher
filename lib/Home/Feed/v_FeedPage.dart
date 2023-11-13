import 'package:capstone/DataVO/model.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'v_FeedCardWidget.dart';
import 'package:capstone/Home/Feed/c_FeedPageController.dart';

class FeedsView extends StatefulWidget {
  const FeedsView({Key? key}) : super(key: key);

  @override
  State<FeedsView> createState() => FeedPageState();
}

class FeedPageState extends State<FeedsView> {
  late ScrollController _scrollController;
  late List<int> items;
  static late List<FeedDataVO> FollowedFeeds = [];
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    items = List.generate(3, (index) => index);
    _scrollController.addListener(_scrollListener);

    Future.delayed(Duration(seconds: 2), () async {
      FollowedFeeds = await FeedController.getFollowedFeeds();
      logger.d(FollowedFeeds);
      setState(() {}); // 상태를 갱신하여 UI를 다시 빌드
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      addItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == items.length) {
          return SizedBox(height: 30); // 로딩 인디케이터 또는 간격
        }
        return FeedPageWidget(
          FollowedFeeds: FollowedFeeds,
        );
      },
    );
  }

  void addItems() {
    setState(() {
      items.addAll(List.generate(3, (index) => index + items.length));
    });
  }
}
