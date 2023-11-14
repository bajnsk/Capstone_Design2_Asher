import 'package:capstone/DataVO/model.dart';
import '../../main.dart';

class MyController {
  static Future<List<FeedDataVO>> getMyFeedsList() async {
    // 현재 로그인한 유저의 피드 ID 목록
    late List<dynamic> myFeedIds = DataVO.myUserData.myFeed;
    logger.d(myFeedIds);

    // 피드 ID를 사용하여 실제 피드 데이터를 비동기적으로 가져오기
    List<FeedDataVO> myFeedsList = await fetchMyFeedsList(myFeedIds);

    // 피드를 날짜 기준으로 정렬
    myFeedsList.sort((a, b) => b.makeTime.compareTo(a.makeTime));
    for (FeedDataVO f in myFeedsList) {
      print(f.feedId);
    }
    logger.d(myFeedsList);

    return myFeedsList;
  }

  static Future<List<FeedDataVO>> fetchMyFeedsList(
      List<dynamic> feedIds) async {
    // 실제 피드 데이터를 비동기적으로 가져오기
    return DataVO.feedData
        .where((feed) => feedIds.contains(feed.feedId))
        .toList();
  }

  static Future<List<FeedDataVO>> getiLikeFeedsList() async {
    // 현재 로그인한 유저의 피드 ID 목록
    late List<dynamic> iLikeFeedIds = DataVO.myUserData.likeFeed;
    logger.d(iLikeFeedIds);

    // 피드 ID를 사용하여 실제 피드 데이터를 비동기적으로 가져오기
    List<FeedDataVO> iLikeFeedsList = await fetchiLikeFeedsList(iLikeFeedIds);

    // 피드를 날짜 기준으로 정렬
    iLikeFeedsList.sort((a, b) => b.makeTime.compareTo(a.makeTime));
    for (FeedDataVO f in iLikeFeedsList) {
      print(f.feedId);
    }
    logger.d(iLikeFeedsList);

    return iLikeFeedsList;
  }

  static Future<List<FeedDataVO>> fetchiLikeFeedsList(
      List<dynamic> feedIds) async {
    // 실제 피드 데이터를 비동기적으로 가져오기
    return DataVO.feedData
        .where((feed) => feedIds.contains(feed.feedId))
        .toList();
  }
}
