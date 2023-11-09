import 'package:flutter/material.dart';
import 'feed_card.dart';

class FeedsView extends StatefulWidget {
  const FeedsView({super.key});

  @override
  State<FeedsView> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FeedsView> {
  late ScrollController _scrollController;
  late List<int> items;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    items = List.generate(30, (index) => index);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
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
          return SizedBox(height: 20); // 로딩 인디케이터 또는 간격
        }
        return FeedCard(number: items[index]);
      },
    );
  }

  void addItems() {
    setState(() {
      items.addAll(List.generate(10, (index) => index + items.length));
    });
  }
}