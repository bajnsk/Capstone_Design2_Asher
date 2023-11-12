import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Appbar/v_appbar_widget.dart';

class FeedGenerator extends StatefulWidget {
  @override
  _FeedGeneratorState createState() => _FeedGeneratorState();
}

class _FeedGeneratorState extends State<FeedGenerator> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _friendNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 데이터를 Firestore에 추가하는 함수
  Future<void> addFeedToFirestore(String contentText) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Get the user document from the 'users' collection using the UID
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          String userName = userDoc['name'];

          // Add a new document to the 'feeds' collection
          DocumentReference<Map<String, dynamic>> docRef =
          await _firestore.collection('feeds').add({
            'makeTime': DateTime.now(),
            'content_text': contentText,
            'userId': user.uid,
            'reContentId': null,
            'image': [],
            'tag': [],
            'userName': userName, // Set the userName field with the fetched name
          });

          String feedId = docRef.id;
          print('Feed ID: $feedId');

          // Update the 'feedId' field in the document with the generated feedId
          await docRef.update({'feedId': feedId});

          // Update the 'feedIds' array field in the 'users' collection for the current user
          await _firestore.collection('users').doc(user.uid).update({
            'feedIds': FieldValue.arrayUnion([feedId]),
          });
        } else {
          print('User document does not exist');
        }
      }

      print('Feed added to Firestore successfully.');
    } catch (e) {
      print('Error adding feed to Firestore: $e');
    }
  }

  // 친구를 추가하는 함수
  Future<void> addFriendByName(String friendName) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // 이름으로 해당 사용자를 찾음
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('users')
            .where('name', isEqualTo: friendName)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // 찾은 사용자의 UID를 가져와서 친구 목록에 추가
          String friendUid = querySnapshot.docs.first.id;
          await _firestore.collection('users').doc(user.uid).update({
            'friends': FieldValue.arrayUnion([friendUid]),
          });

          // 친구에게도 나를 친구로 등록
          await _firestore.collection('users').doc(friendUid).update({
            'friends': FieldValue.arrayUnion([user.uid]),
          });

          print('Friend added successfully.');
        } else {
          print('User with name $friendName not found.');
        }
      }
    } catch (e) {
      print('Error adding friend: $e');
    }
  }

  // 친구의 피드를 가져오는 함수
  Future<List<Map<String, dynamic>>> getFriendFeeds() async {
    try {
      User? user = _auth.currentUser;
      print(user);

      if (user != null) {
        // 사용자의 문서를 가져옴
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        print(userDoc);

        // 사용자 친구의 uId 목록을 가져옴
        List<dynamic> friendUids = userDoc.data()?['friends'] ?? [];
        print(friendUids);

        // 친구의 feedId 목록을 가져옴
        List<dynamic> friendFeedIds = [];
        print(friendFeedIds);

        // 각 친구의 feedId 목록을 합침
        for (var friendUid in friendUids) {
          DocumentSnapshot<Map<String, dynamic>> friendDoc =
              await _firestore.collection('users').doc(friendUid).get();
          friendFeedIds.addAll(friendDoc.data()?['feedIds'] ?? []);
          print(friendDoc);
        }

        // 사용자와 친구의 feedId 목록을 합침
        List<dynamic> allFeedIds = [...friendFeedIds];
        print(allFeedIds);

        if (allFeedIds.isNotEmpty) {
          // feedId 목록을 사용하여 피드를 가져옴
          QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
              .collection('feeds')
              .where('feedId', whereIn: allFeedIds)
              .orderBy('makeTime', descending: true)
              .get();

          List<Map<String, dynamic>> friendFeeds = querySnapshot.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                  doc.data() as Map<String, dynamic>)
              .toList();
          print(friendFeeds);
          return friendFeeds;
        }
      }

      return [];
    } catch (e) {
      print('친구의 피드를 가져오는 중 오류 발생: $e');
      return [];
    }
  }

// 친구 피드 테스트
  void _fetchFriendFeeds() async {
    List<Map<String, dynamic>> friendFeeds = await getFriendFeeds();

    // 친구의 피드에 대해 처리
    for (var feed in friendFeeds) {
      print('친구 피드 내용: ${feed['content_text']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AsherAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Feed Content'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // 텍스트 필드에서 얻은 내용을 Firestore에 추가
                addFeedToFirestore(_contentController.text);
              },
              child: Text('Add Feed to Firestore'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _friendNameController,
                    decoration: InputDecoration(labelText: 'Friend Name'),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // // 텍스트 필드에서 얻은 이름으로 친구 추가
                    addFriendByName(_friendNameController.text);
                  },
                  child: Text('Add Friend'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // 새로운 버튼을 누를 때 친구 피드를 가져오는 함수 호출
                    _fetchFriendFeeds();
                  },
                  child: Text('Get Friend Feeds'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
