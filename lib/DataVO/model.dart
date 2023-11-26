import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 파베로 부터 받아온 데이터를 리스트 형태로 저장시켜놓는 공간

// 유저 데이터에 대한 모델링 > 리스트
class UserDataVO {
  @override
  String toString() {
    return 'UserDataVO{uId: $uId, followedFeed: $followedFeed, friend: $friend, likeFeed: $likeFeed, userName: $userName, userProfile: $userProfile, tag: $tag, myFeed: $myFeed, statusMessage: $statusMessage}';
  }

  var uId;
  var followedFeed;
  var friend;
  var likeFeed;
  var userName;
  var userProfile;
  var tag;
  var myFeed;
  var statusMessage;

  UserDataVO({
    required this.uId,
    required this.followedFeed,
    required this.friend,
    required this.likeFeed,
    required this.userName,
    required this.userProfile,
    required this.tag,
    required this.myFeed,
    required this.statusMessage,
  });
}

// 피드 데이터에 대한 모델링 > 리스트
class FeedDataVO {
  @override
  String toString() {
    return 'FeedDataVO{feedId: $feedId, userId: $userId, reContentId: $reContentId, context_text: $context_text, image: $image, makeTime: $makeTime, tag: $tag, userName: $userName}';
  }

  var feedId;
  var userId;
  var reContentId;
  var context_text;
  var image;
  var makeTime;
  var tag;
  var userName;

  FeedDataVO({
    required this.feedId,
    required this.userId,
    required this.reContentId,
    required this.context_text,
    required this.image,
    required this.makeTime,
    required this.tag,
    required this.userName,
  });
}

// 나와 연관된 피드 데이터에 대한 모델링 > 리스트
class RelationFeedDataVO {}

class DataVO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchUserData() async {
    try {
      // 인증된 사용자 가져오기
      User? user = _auth.currentUser;

      if (user != null) {
        // 'users' 컬렉션에서 UID를 사용하여 사용자 문서 가져오기
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        // 문서가 존재하는지 확인
        if (userDoc.exists) {
          // 문서 데이터를 UserDataVO로 매핑
          Map<String, dynamic>? userDataMap =
              userDoc.data() as Map<String, dynamic>?;

          if (userDataMap != null && userDataMap.containsKey('userId')) {
            myUserData = UserDataVO(
              uId: userDataMap['userId'],
              followedFeed: userDataMap['followedFeed'],
              friend: userDataMap['friends'],
              likeFeed: userDataMap['like'],
              userName: userDataMap['name'],
              userProfile: userDataMap['profileImage'],
              tag: userDataMap['tag'],
              myFeed: userDataMap['feedIds'],
              statusMessage: userDataMap['status_message']
            );
          } else {
            print('사용자 문서에 필수 필드가 누락되었습니다.');
          }
        } else {
          // 문서가 존재하지 않을 때 처리
          print('사용자 문서가 존재하지 않습니다.');
        }
      } else {
        // 사용자가 인증되지 않았을 때 처리
        print('사용자가 인증되지 않았습니다.');
      }
    } catch (e) {
      // 예외 처리
      print('사용자 데이터를 가져오는 중 오류 발생: $e');
    }
  }

  Future<void> fetchFeedData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> feedDocs =
          await _firestore.collection('feeds').get();

      feedData =
          feedDocs.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return FeedDataVO(
          feedId: doc['feedId'],
          userId: doc['userId'],
          reContentId: doc['reContentId'],
          context_text: doc['content_text'],
          image: doc['image'],
          makeTime: doc['makeTime'],
          tag: doc['tag'],
          userName: doc['userName'],
        );
      }).toList();
      print('피드 데이터 성공적으로 가져옴.');
    } catch (e) {
      print('피드 데이터 가져오는 중 오류 발생: $e');
    }
  }

  void init() async {
    try {
      // 로그인 후 불러 와야할 데이터 모델들을 정의
      // 사용자 인증 => DataVO 인스턴스 초기화 후 fetchData 호출 해야 함
      await fetchUserData();
      await fetchFeedData();
      //updateLikeFeedData();
    } catch (e) {
      // 에러 처리
      print('데이터 초기화 중 오류 발생: $e');
    }
  }

  //DB 받아오기
  static List<UserDataVO> userData = [];
  static late UserDataVO myUserData;
  // 전체 Feed data 리스트 화 => DB에서 받아오기
  static List<FeedDataVO> feedData = [];
}
