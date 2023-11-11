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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 데이터를 Firestore에 추가하는 함수
  Future<void> addFeedToFirestore(String contentText) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // 'feeds' 컬렉션에 데이터 추가
        DocumentReference<Map<String, dynamic>> docRef =
            await _firestore.collection('feeds').add({
          'makeTime': DateTime.now(),
          'content_text': contentText,
          'userId': user.uid, // 현재 로그인한 사용자의 UID 저장
        });
        String feedId = docRef.id;
        print('Feed ID: $feedId');

        // feedId 추가
        await docRef.update({'feedId': feedId});
      }
      print('Feed added to Firestore successfully.');
    } catch (e) {
      print('Error adding feed to Firestore: $e');
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
          ],
        ),
      ),
    );
  }
}
