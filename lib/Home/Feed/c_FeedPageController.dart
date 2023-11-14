import 'package:capstone/DataVO/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';

import 'dart:async';

class FeedController {
  static Future<List<FeedDataVO>> getFollowedFeeds() async {
    List<dynamic> followedFeedIds = DataVO.myUserData.followedFeed;
    logger.d(followedFeedIds);

    List<FeedDataVO> followedFeeds = await _fetchFollowedFeeds(followedFeedIds);

    followedFeeds.sort((a, b) => b.makeTime.compareTo(a.makeTime));
    for (FeedDataVO f in followedFeeds) {
      print(f.feedId);
    }
    logger.d(followedFeeds);

    return followedFeeds;
  }

  static Future<List<FeedDataVO>> _fetchFollowedFeeds(
      List<dynamic> feedIds) async {
    return DataVO.feedData
        .where((feed) => feedIds.contains(feed.feedId))
        .toList();
  }
}

class FeedTypeController {
  static final FeedTypeController instance = FeedTypeController.internal();

  factory FeedTypeController() {
    return instance;
  }

  FeedTypeController.internal();

  String makeTimeTodate(FeedDataVO feedData) {
    Timestamp timestamp = feedData.makeTime;
    DateTime dateTime = timestamp.toDate();

    String formattedDateTime =
        "${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}";
    return formattedDateTime;
  }
}
