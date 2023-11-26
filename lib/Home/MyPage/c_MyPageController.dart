import 'package:capstone/DataVO/model.dart';

class MyController {
  static List<FeedDataVO> myFeedsList = [];
  static List<FeedDataVO> iLikeFeedsList = [];

  // 사용자의 프로필 이미지 가져오기
  static String getUserProfileImage() {
    return DataVO.myUserData.userProfile;
  }

  // 사용자의 상태 메시지 가져오기
  static String getUserStatusMessage() {
    return DataVO.myUserData.statusMessage;
  }

  // 내 피드 불러오기
  static Future<List<FeedDataVO>> getMyFeedsList() async {
    // 현재 로그인한 유저의 피드 ID 목록
    late List<dynamic> myFeedIds = DataVO.myUserData.myFeed;

    // 피드 ID를 사용하여 실제 피드 데이터를 비동기적으로 가져오기
    List<FeedDataVO> myFeedsList = await fetchMyFeedsList(myFeedIds);

    // 피드를 날짜 기준으로 정렬
    myFeedsList.sort((a, b) => b.makeTime.compareTo(a.makeTime));
    for (FeedDataVO f in myFeedsList) {
      print(f.feedId);
    }

    return myFeedsList;
  }

  static Future<List<FeedDataVO>> fetchMyFeedsList(
      List<dynamic> feedIds) async {
    // 실제 피드 데이터를 비동기적으로 가져오기
    return DataVO.feedData
        .where((feed) => feedIds.contains(feed.feedId))
        .toList();
  }

  // 내가 좋아요한 피드 불러오기
  static Future<List<FeedDataVO>> getiLikeFeedsList() async {
    // 현재 로그인한 유저의 피드 ID 목록
    late List<dynamic> iLikeFeedIds = DataVO.myUserData.likeFeed;
    print(DataVO.myUserData.likeFeed);

    // 피드 ID를 사용하여 실제 피드 데이터를 비동기적으로 가져오기
    List<FeedDataVO> iLikeFeedsList = await fetchiLikeFeedsList(iLikeFeedIds);

    // 피드를 날짜 기준으로 정렬
    iLikeFeedsList.sort((a, b) => b.makeTime.compareTo(a.makeTime));

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
