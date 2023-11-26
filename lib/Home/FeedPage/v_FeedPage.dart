import 'package:capstone/DataVO/model.dart';
import 'package:flutter/material.dart';
import 'package:capstone/Home/FeedPage/v_AllFeedCheckedWidget.dart';
import 'v_FeedCardWidget.dart';
import 'package:capstone/Home/FeedPage/c_FeedPageController.dart';

class FeedsView extends StatefulWidget {
  const FeedsView({Key? key}) : super(key: key);

  @override
  State<FeedsView> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedsView> {
  late ScrollController _scrollController;
  late List<int> items;
  late int index;
  late List<FeedDataVO> FollowedFeeds = [];
  bool allFeedsChecked = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    items = List.generate(3, (index) => index);
    _scrollController.addListener(_scrollListener);

    Future.delayed(Duration(seconds: 1), () async {
      FollowedFeeds = await FeedController.getFollowedFeeds();
      setState(() {});
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

  void addItems() {
    setState(() {
      if (items.length < FollowedFeeds.length) {
        items.addAll(List.generate(3, (index) => index + items.length));
      } else {
        allFeedsChecked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: allFeedsChecked ? FollowedFeeds.length + 1 : items.length,
      itemBuilder: (BuildContext context, int index) {
        if (index < FollowedFeeds.length) {
          FeedDataVO feedData = FollowedFeeds[index];
          return FeedCardWidget(
            FollowedFeeds: FollowedFeeds,
            feedData: feedData,
            index: index,
          );
        } else if (allFeedsChecked) {
          // 모든 데이터를 로드한 경우 특정 위젯을 표시
          return AllFeedsCheckedWidget();
        } else if (!allFeedsChecked && index == items.length - 1) {
          // 로딩 중에는 디자인된 CircularProgressIndicator를 표시
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              strokeWidth: 4,
            ),
          );
        } else {
          // 더 이상 아이템이 없으면 빈 컨테이너를 반환하거나 다른 로딩 상태를 표시할 수 있습니다.
          return Container();
        }
      },
    );
  }
}
