import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../main.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;

class FeedGenerator extends StatefulWidget {
  @override
  _FeedGeneratorState createState() => _FeedGeneratorState();
}

class _FeedGeneratorState extends State<FeedGenerator> {
  final TextEditingController _contentController = TextEditingController();
  // final TextEditingController _friendNameController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Uint8List? _imageBytes;
  bool _isUploading = false;
  String defaultImageUrl = 'https://firebasestorage.googleapis.com/v0/b/capstone2-1ad1d.appspot.com/o/selectImage.png?alt=media&token=a29e386f-93f4-4f53-a3b2-dd74378c9088';

  @override
  void initState() {
    super.initState();
    // 위젯 초기화시 기본 이미지 로드
    _loadImageFromUrl(defaultImageUrl).then((imageBytes) {
      setState(() {
        _imageBytes = imageBytes;
      });
    }).catchError((error) {
      print('기본 이미지 로드 실패: $error');
    });
  }

  // Firestore 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Uint8List를 파일로 변환하는 함수
  Future<io.File> _createTempFile(Uint8List bytes) async {
    final tempDir = await io.Directory.systemTemp;
    final tempFile = io.File('${tempDir.path}/temp_image.png');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    return image;
  }

  // 데이터를 Firestore에 추가하는 함수
  Future<void> _addFeedToFirestore(
      String contentText, String imagePath, String tag) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // uid를 사용해 users 컬렉션 탐색
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          String userName = userDoc['name'];

          // 파일 이름을 UUID로 생성하고 확장자를 .jpg로 설정
          String fileName = Uuid().v4() + '.jpg';

          Reference firebaseStorageRef =
              FirebaseStorage.instance.ref().child(fileName);

          // 파일의 MIME 타입을 명시적으로 지정
          String mimeType = 'image/jpeg';
          SettableMetadata metadata = SettableMetadata(contentType: mimeType);

          // 이미지를 Firebase Storage에 업로드
          UploadTask uploadTask =
              firebaseStorageRef.putFile(io.File(imagePath), metadata);

          TaskSnapshot taskSnapshot = await uploadTask;
          logger.d('Image uploaded to Firebase Storage: ${taskSnapshot.ref}');

          // Firebase Storage에 업로드된 이미지의 다운로드 URL을 가져옴
          String imageUrl = await taskSnapshot.ref.getDownloadURL();

          // Firestore에 피드 추가
          DocumentReference<Map<String, dynamic>> docRef =
              await _firestore.collection('feeds').add({
            'makeTime': DateTime.now(),
            'content_text': contentText,
            'userId': user.uid,
            'reContentId': null,
            'image': imageUrl.isNotEmpty ? [imageUrl] : [],
            'tag': [tag],
            'userName': userName,
          });

          String feedId = docRef.id;
          logger.d('Feed ID: $feedId');

          // feedid에 생성된 feedid 저장
          await docRef.update({'feedId': feedId});

          // 현재 사용자를 위한 'users' 컬렉션의 'feedIds' 배열 필드 업데이트
          await _firestore.collection('users').doc(user.uid).update({
            'feedIds': FieldValue.arrayUnion([feedId]),
          });

          logger.d('Feed added to Firestore successfully.');
        } else {
          logger.d('User document does not exist');
        }
      }
    } catch (e) {
      logger.d('Error adding feed to Firestore: $e');
    }
  }



  // _pickImage 함수를 수정하여 XFile을 반환하도록 수정
  Future<void> _pickImage() async {
    final XFile? image = await pickImage();

    if (image != null) {
      // 이미지를 파일로 변환
      io.File file = io.File(image.path);

      // 파일을 Uint8List로 변환
      List<int> bytes = await file.readAsBytes();
      Uint8List uint8List = Uint8List.fromList(bytes);

      // 이미지를 Uint8List로 설정
      setState(() {
        _imageBytes = uint8List;
      });
    }
  }

  // uploadImageToFirebaseStorage 함수의 매개변수를 XFile에서 io.File로 변경
  Future<void> uploadImageToFirebaseStorage(io.File file) async {
    try {
      // 파일 이름을 UUID로 생성하고 확장자를 .jpg로 설정
      String fileName = Uuid().v4() + '.jpg';

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);

      // 파일의 MIME 타입을 명시적으로 지정
      String mimeType = 'image/jpeg';
      SettableMetadata metadata = SettableMetadata(contentType: mimeType);

      UploadTask uploadTask = firebaseStorageRef.putFile(file, metadata);

      TaskSnapshot taskSnapshot = await uploadTask;
      logger.d('Image uploaded to Firebase Storage: ${taskSnapshot.ref}');
    } catch (e) {
      logger.d('Error uploading image to Firebase Storage: $e');
    }
  }

  // 이미지 URL을 Uint8List로 변환하는 함수
  Future<Uint8List> _loadImageFromUrl(String imageUrl) async {
    if (imageUrl.startsWith('http')) {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return Uint8List.fromList(response.bodyBytes);
      } else {
        throw Exception('이미지 로드 실패');
      }
    } else {
      // AssetImage를 사용하여 로컬 이미지 불러오기
      final ByteData data = await rootBundle.load(imageUrl);
      return data.buffer.asUint8List();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: [
                if (_imageBytes != null)
                  Image.memory(
                    _imageBytes!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ElevatedButton(
                  onPressed: () {
                    // 이미지 선택
                    _pickImage();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[300]!),
                  ),
                  child: Text(
                    'Select Image',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                // 이미지 업로드 중일 때 표시되는 위젯
                if (_isUploading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 2),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0,7),
                      )
                    ]
                  ),
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  height: 150,
                  width: MediaQuery.of(context).size.width-50,
                  child: TextFormField(
                    controller: _contentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '내용을 입력하세요.',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 2),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0,5),
                      )
                    ]
                  ),
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  height: 50,
                  width: MediaQuery.of(context).size.width-50,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _tagController,
                    decoration: InputDecoration(
                      hintText: '태그를 입력하세요.',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () async {
                    if (_imageBytes != null) {
                      FocusScope.of(context).unfocus();
                      // 이미지가 선택되었을 때만 피드 저장
                      // 이미지 파일의 경로를 얻어 Firebase Storage에 업로드

                      // 임시 파일 생성
                      io.File file = await _createTempFile(_imageBytes!);
                      await uploadImageToFirebaseStorage(file);
                      // 텍스트 필드에서 얻은 내용을 Firestore에 추가
                      await _addFeedToFirestore(
                        _contentController.text,
                        file.path,
                        _tagController.text,
                      );// 이미지 파일의 경로를 사용
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Feed를 등록했습니다.')),
                      );
                    } else {
                      // 이미지가 선택되지 않은 경우에 대한 처리
                      print(
                          'Please select an image before adding feed to Firestore.');
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[300]!),
                  ),
                  child: Text(
                    'Upload Feed',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextField(
                //         controller: _friendNameController,
                //         decoration: InputDecoration(labelText: 'Friend Name'),
                //       ),
                //     ),
                //     SizedBox(width: 8.0),
                //     ElevatedButton(
                //       onPressed: () {
                //         // // 텍스트 필드에서 얻은 이름으로 친구 추가
                //         addFriendByName(_friendNameController.text);
                //       },
                //       child: Text('Add Friend'),
                //     ),
                //     SizedBox(width: 8.0),
                //   ],
                // ),
              ],
            ),
        ),
        ),
    );
  }
}
