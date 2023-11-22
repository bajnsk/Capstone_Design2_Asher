import 'package:capstone/DataVO/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

class FeedController {
  static Future<List<FeedDataVO>> getFollowedFeeds() async {
    List<dynamic> followedFeedIds = DataVO.myUserData.followedFeed;

    List<FeedDataVO> followedFeeds = await _fetchFollowedFeeds(followedFeedIds);

    followedFeeds.sort((a, b) => b.makeTime.compareTo(a.makeTime));
    for (FeedDataVO f in followedFeeds) {
      print(f.feedId);
    }

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

  Future<void> likeFeedToFirebase(FeedDataVO feedData) async {
    try {
      // 사용자의 UID 가져오기
      String userUid = DataVO.myUserData.uId;

      // 'users' 컬렉션에서 사용자 UID 문서 업데이트
      await FirebaseFirestore.instance.collection('users').doc(userUid).update({
        'like': FieldValue.arrayUnion([feedData.feedId]),
      });

      print('피드를 좋아요 목록에 추가했습니다.');
    } catch (e) {
      print('피드를 좋아요 목록에 추가하는 중 오류 발생: $e');
    }
  }

  Future<void> unlikeFeedFromFirebase(FeedDataVO feedData) async {
    try {
      // 사용자의 UID 가져오기
      String userUid = DataVO.myUserData.uId;

      // 'users' 컬렉션에서 사용자 UID 문서 업데이트
      await FirebaseFirestore.instance.collection('users').doc(userUid).update({
        'like': FieldValue.arrayRemove([feedData.feedId]),
      });

      print('피드를 좋아요 목록에서 제거했습니다.');
    } catch (e) {
      print('피드를 좋아요 목록에서 제거하는 중 오류 발생: $e');
    }
  }
}
