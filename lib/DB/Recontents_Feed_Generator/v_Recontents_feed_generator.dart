import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../DataVO/model.dart';
import '../../main.dart';
import 'dart:io' as io;

class RecontentsFeedGenerator extends StatefulWidget {
  final feedData;

  const RecontentsFeedGenerator({
    Key? key,
    required this.feedData,
  }) : super(key: key);

  @override
  RecontentsFeedGeneratorState createState() => RecontentsFeedGeneratorState();
}

// Feed 생성할 때 리컨텐츠 Id => 원본 피드 Id 넣어주는 작업
class RecontentsFeedGeneratorState extends State<RecontentsFeedGenerator> {
  late TextEditingController _contentController = TextEditingController();
  late TextEditingController _tagController = TextEditingController();

  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    print('Feed Data: ${widget.feedData}');
    logger.d(widget.feedData.feedId);

    if (widget.feedData != null) {
      print('Feed Image URLs: ${widget.feedData.image}');
      // 이미지 URL을 문자열로 변환하여 _files 리스트에 추가
      _files.addAll((widget.feedData.image as List<dynamic>)
          .map((imageUrl) => imageUrl.toString()));
    } else {
      print('Feed Data is null.');
    }

    _contentController = TextEditingController(
        text: widget.feedData != null
            ? widget.feedData.context_text.toString()
            : '');
    _tagController = TextEditingController(
        text: widget.feedData != null ? widget.feedData.tag.toString() : '');
    if (_tagController.text.isNotEmpty) {
      _tagController.text =
          _tagController.text.substring(1, _tagController.text.length - 1);
    }
  }

  Future<void> _showSnackBar(String message) async {
    // Find the Scaffold in the widget tree and use it to show a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1), // Displayed for 2 seconds
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isUploading = false;
  final List<String> _files = [];

  // Firestore 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 이미지 선택 함수
  Future<List<String>> selectImages() async {
    List<XFile> images = await ImagePicker().pickMultiImage(
      maxHeight: 1024,
      maxWidth: 1024,
    );
    return images.map((e) => e.path).toList();
  }

  // 이미지를 표시하는 함수
  List<Widget> selectedImageList() {
    List<Widget> imageWidgets = [];

    for (String imagePath in _files) {
      Widget imageWidget;

      if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
        // 원격 이미지인 경우
        imageWidget = Image.network(
          imagePath,
          fit: BoxFit.cover,
          height: 200,
          width: MediaQuery.of(context).size.width - 50,
        );
      } else {
        // 로컬 파일인 경우
        imageWidget = Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                height: 200,
                width: MediaQuery.of(context).size.width - 50,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _files.remove(imagePath);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  height: 30,
                  width: 30,
                  child: Icon(
                    color: Colors.black.withOpacity(0.6),
                    size: 30,
                    Icons.highlight_remove_outlined,
                  ),
                ),
              ),
            ),
          ],
        );
      }

      imageWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: imageWidget,
        ),
      );
    }

    // Add the 'Add Photo' option
    imageWidgets.add(
      InkWell(
        onTap: () async {
          final images = await selectImages();
          setState(() {
            _files.addAll(
                images.where((imagePath) => !_files.contains(imagePath)));
          });
        },
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            Icons.add_a_photo_outlined,
            size: 50,
          ),
        ),
      ),
    );

    return imageWidgets;
  }

  // 데이터를 Firestore에 추가하는 함수
  Future<void> _addFeedToFirestore(
    String contentText,
    List<String> imagePaths,
    String tagText,
    String? reContentId,
  ) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // uid를 사용해 users 컬렉션 탐색
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          String userName = userDoc['name'];
          String UserProfile = userDoc['profileImage'];

          // 태그 #으로 배열화
          List<String> tags = tagText
              .split('#')
              .where((tag) => tag.trim().isNotEmpty)
              .map((tag) => '#${tag.trim()}')
              .toList();

          List<String> imageUrls = [];

          for (String imagePath in imagePaths) {
            // 이미지의 URL이라면 Image.network를 사용하여 Uint8List로 변환
            if (imagePath.startsWith('http')) {
              var response = await dio.get(
                imagePath,
                options: Options(responseType: ResponseType.bytes),
              );
              var byteData = Uint8List.fromList(response.data);

              Reference firebaseStorageRef =
                  FirebaseStorage.instance.ref().child(Uuid().v4() + '.jpg');

              // 이미지를 Firebase Storage에 업로드
              UploadTask uploadTask =
                  firebaseStorageRef.putData(byteData); // putData로 변경

              TaskSnapshot taskSnapshot = await uploadTask;
              logger
                  .d('Image uploaded to Firebase Storage: ${taskSnapshot.ref}');

              // Firebase Storage에 업로드된 이미지의 다운로드 URL을 가져옴
              String imageUrl = await taskSnapshot.ref.getDownloadURL();
              imageUrls.add(imageUrl);
            } else {
              // 이미지가 로컬 파일이라면 기존 코드 사용
              String fileName = Uuid().v4() + '.jpg';
              Reference firebaseStorageRef =
                  FirebaseStorage.instance.ref().child(fileName);
              String mimeType = 'image/jpeg';
              SettableMetadata metadata =
                  SettableMetadata(contentType: mimeType);
              UploadTask uploadTask =
                  firebaseStorageRef.putFile(io.File(imagePath), metadata);
              TaskSnapshot taskSnapshot = await uploadTask;
              logger
                  .d('Image uploaded to Firebase Storage: ${taskSnapshot.ref}');
              String imageUrl = await taskSnapshot.ref.getDownloadURL();
              imageUrls.add(imageUrl);
            }
          }

          // Firestore에 피드 추가
          DocumentReference<Map<String, dynamic>> docRef =
              await _firestore.collection('feeds').add({
            'makeTime': DateTime.now(),
            'content_text': contentText,
            'userId': user.uid,
            'reContentId': reContentId ?? null,
            'image': imageUrls.isNotEmpty ? imageUrls : [],
            'tag': tags,
            'userName': userName,
            'userProfile': UserProfile,
          });

          String feedId = docRef.id;
          logger.d('Feed ID: $feedId');

          // feedid에 생성된 feedid 저장
          await docRef.update({'feedId': feedId});

          DataVO().init();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리컨텐츠 피드 작성'),
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
        child: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.7,
                      ),
                      top: BorderSide(
                        color: Colors.grey,
                        width: 0.7,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                          DataVO.myUserData.userProfile,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(DataVO.myUserData.userName),
                      Spacer(), // 여기에 Spacer 추가
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width - 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        if (_files.isEmpty)
                          InkWell(
                            onTap: () async {
                              final images = await selectImages();
                              setState(() {
                                _files.addAll(images.where((imagePath) =>
                                    !_files.contains(imagePath)));
                              });
                            },
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 50,
                              ),
                            ),
                          ),
                        ...selectedImageList(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // 이미지 업로드 중일 때 표시되는 위젯
                if (_isUploading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: _contentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: '내용을 입력하세요.',
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                ),
                //),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _tagController,
                    decoration: InputDecoration(
                        hintText: '태그를 입력하세요.',
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_files.isNotEmpty) {
                      FocusScope.of(context).unfocus();
                      // 이미지가 선택되었을 때만 피드 저장
                      // 텍스트 필드에서 얻은 내용을 Firestore에 추가
                      await _addFeedToFirestore(
                        _contentController.text,
                        _files,
                        _tagController.text,
                        widget.feedData != null ? widget.feedData.feedId : null,
                      ); // 이미지 파일의 경로를 사용

                      // Feed 등록 후 이전 화면으로 돌아가기
                      _showSnackBar('해당 피드가 리컨텐츠 피드로 등록되었습니다.');
                      Navigator.of(context).pop();
                    } else {
                      // 이미지가 선택되지 않은 경우에 대한 처리
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('이미지를 선택해주세요')),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey[300]!),
                  ),
                  child: Text(
                    'Upload Feed',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
