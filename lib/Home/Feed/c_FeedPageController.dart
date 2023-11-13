import 'package:capstone/DataVO/model.dart';

import '../../main.dart';

class FeedController {
  static Future<List<FeedDataVO>> getFollowedFeeds() async {
    // 현재 로그인한 유저의 피드 ID 목록
    late List<dynamic> followedFeedIds = DataVO.myUserData.followedFeed;
    logger.d(followedFeedIds);

    // 피드 ID를 사용하여 실제 피드 데이터를 비동기적으로 가져오기
    List<FeedDataVO> followedFeeds = await fetchFollowedFeeds(followedFeedIds);

    // 피드를 날짜 기준으로 정렬
    followedFeeds.sort((a, b) => b.makeTime.compareTo(a.makeTime));
    for (FeedDataVO f in followedFeeds) {
      print(f.feedId);
    }
    logger.d(followedFeeds);

    return followedFeeds;
  }

  static Future<List<FeedDataVO>> fetchFollowedFeeds(List<dynamic> feedIds) async {
    // 실제 피드 데이터를 비동기적으로 가져오기
    return DataVO.feedData
        .where((feed) => feedIds.contains(feed.feedId))
        .toList();
  }
}