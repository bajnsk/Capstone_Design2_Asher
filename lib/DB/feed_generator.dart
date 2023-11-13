import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Appbar/v_appbar_widget.dart';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../main.dart';

class FeedGenerator extends StatefulWidget {
  @override
  _FeedGeneratorState createState() => _FeedGeneratorState();
}

class _FeedGeneratorState extends State<FeedGenerator> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _friendNameController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Uint8List? _imageBytes;
  bool _isUploading = false;

  // Firestore 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 데이터를 Firestore에 추가하는 함수
  Future<void> addFeedToFirestore(String contentText, String fileName,String tag) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // uid를 사용해 users 컬렉션 탐색
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
            'image': fileName.isNotEmpty ? [fileName] : [], // Use list for multiple images
            'tag': tag,
            'userName': userName,
          });

          String feedId = docRef.id;
          logger.d('Feed ID: $feedId');

          // feedid에 생성된 feedid 저장
          await docRef.update({'feedId': feedId});

          // Update the 'feedIds' array field in the 'users' collection for the current user
          await _firestore.collection('users').doc(user.uid).update({
            'feedIds': FieldValue.arrayUnion([feedId]),
          });
        } else {
          logger.d('User document does not exist');
        }
      }

      logger.d('Feed added to Firestore successfully.');
    } catch (e) {
      logger.d('Error adding feed to Firestore: $e');
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

          logger.d('Friend added successfully.');
        } else {
          logger.d('User with name $friendName not found.');
        }
      }
    } catch (e) {
      logger.d('Error adding friend: $e');
    }
  }

  // 이미지 추가 함수
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // 이미지를 Uint8List로 변환
      List<int> imageBytes = await image.readAsBytes();
      setState(() {
        _imageBytes = Uint8List.fromList(imageBytes);
      });
    }
  }

  //이미지 Storage에 저장
  Future<void> uploadImageToFirebaseStorage(Uint8List imageBytes, String fileName) async {
    try {
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putData(imageBytes);

      TaskSnapshot taskSnapshot = await uploadTask;
      logger.d('Image uploaded to Firebase Storage: ${taskSnapshot.ref}');

    } catch (e) {
      logger.d('Error uploading image to Firebase Storage: $e');
    }
  }

  // Firestore Database에 이미지 파일 이름 저장


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AsherAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_imageBytes != null)
              Image.memory(
                _imageBytes!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 이미지 선택
                _pickImage();
              },
              child: Text('Select Image'),
            ),
            // 이미지 업로드 중일 때 표시되는 위젯
            if (_isUploading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Feed Content'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _tagController,
              decoration: InputDecoration(labelText: 'tag'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_imageBytes != null) {
                  // 이미지가 선택되었을 때만 피드 저장
                  // Firebase Storage에 이미지 업로드
                  String fileName = Uuid().v4(); // UUID로 파일 이름 생성
                  uploadImageToFirebaseStorage(_imageBytes!, fileName);

                  // 텍스트 필드에서 얻은 내용을 Firestore에 추가
                  addFeedToFirestore(_contentController.text, fileName, _tagController.text);
                } else {
                  // 이미지가 선택되지 않은 경우에 대한 처리
                  print('Please select an image before adding feed to Firestore.');
                }
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
