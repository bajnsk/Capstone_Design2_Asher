import 'package:capstone/DataVO/model.dart';

class FeedController {
  static List<FeedDataVO> FollowedFeeds = [];
  // 현재 로그인한 유저의 피드를 가져오는 메서드
  static List<FeedDataVO> getFollowedFeeds() {
    // 현재 로그인한 유저의 피드 ID 목록
    late List<String> FollowedFeedIds = DataVO.myUserData.followedFeed;

    // 피드 ID를 사용하여 실제 피드 데이터를 가져오기
    late List<FeedDataVO> FollowedFeeds = DataVO.feedData
        .where((feed) => FollowedFeedIds.contains(feed.feedId))
        .toList();

    // 피드를 날짜 기준으로 정렬
    FollowedFeeds.sort((a, b) => b.makeTime.compareTo(a.makeTime));

    return FollowedFeeds;
  }

  // 피드 페이지를 로드하는 메서드

// 추가적으로 필요한 메서드나 변수를 정의할 수 있습니다.
}
