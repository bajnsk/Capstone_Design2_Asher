import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';
import 'package:capstone/DataVO/model.dart';

class FriendController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 친구를 추가하는 함수
  Future<void> addFriendByName(String friendid) async {
    try {
      User? user = _auth.currentUser;

      if (user != null && friendid != user.uid) {
        // 친구의 문서 가져오기
        DocumentSnapshot<Map<String, dynamic>> friendUserDoc =
            await _firestore.collection('users').doc(friendid).get();

        // 현재 사용자와 친구의 UID 가져오기
        String currentUserUid = user.uid;
        String friendUid = friendUserDoc.id;

        // 서로의 'friends' 필드에 추가
        await _firestore.collection('users').doc(currentUserUid).update({
          'friends': FieldValue.arrayUnion([friendUid]),
        });

        await _firestore.collection('users').doc(friendUid).update({
          'friends': FieldValue.arrayUnion([currentUserUid]),
        });

        DataVO.myUserData.friend.add(friendUid);
        DataVO();

        logger.d('친구가 성공적으로 추가되었습니다.');
      } else {
        logger.d('유효하지 않은 친구 UID: $friendid');
      }
    } catch (e) {
      logger.d('친구 추가 중 오류 발생: $e');
    }
  }

  // 친구를 삭제하는 함수
  Future<void> removeFriendByName(String friendid) async {
    try {
      User? user = _auth.currentUser;

      if (user != null && friendid != user.uid) {
        // 친구의 문서 가져오기
        DocumentSnapshot<Map<String, dynamic>> friendUserDoc =
            await _firestore.collection('users').doc(friendid).get();

        // 현재 사용자와 친구의 UID 가져오기
        String currentUserUid = user.uid;
        String friendUid = friendUserDoc.id;

        // 서로의 'friends' 필드에서 삭제
        await _firestore.collection('users').doc(currentUserUid).update({
          'friends': FieldValue.arrayRemove([friendUid]),
        });

        await _firestore.collection('users').doc(friendUid).update({
          'friends': FieldValue.arrayRemove([currentUserUid]),
        });
        DataVO().init();
        logger.d('친구가 성공적으로 삭제되었습니다.');
      } else {
        logger.d('유효하지 않은 친구 UID: $friendid');
      }
    } catch (e) {
      logger.d('친구 삭제 중 오류 발생: $e');
    }
  }
}
