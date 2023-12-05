import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyPageEditProfilePopup extends StatefulWidget {
  const MyPageEditProfilePopup({super.key});

  @override
  State<MyPageEditProfilePopup> createState() => _MyPageEditProfilePopupState();
}

class _MyPageEditProfilePopupState extends State<MyPageEditProfilePopup> {
  File? _imageFile;
  TextEditingController _statusMessageController = TextEditingController();

  // 이미지 선택
  Future<void> pickImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _showSnackBar(String message) async {
    // Find the Scaffold in the widget tree and use it to show a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Displayed for 2 seconds
      ),
    );
  }

  Future<void> uploadProfileData(File? imageFile, String message) async {
    if (imageFile != null) {
      await uploadProfileImage(imageFile);
      await updateStatusMessage(message);
    }
  }

  Future<void> updateStatusMessage(String message) async {
    // 사용자 문서 업데이트
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'status_message': message,
      });
      DataVO.myUserData.statusMessage = null;
      DataVO.myUserData.statusMessage = message;
    }
  }

  // 이미지를 Firebase Storage에 업로드
  Future<void> uploadProfileImage(File imageFile) async {
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        'user_profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    // 사용자 문서 업데이트
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'profileImage': imageUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Profile',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: 300,
          height: 200,
          child: Stack(alignment: Alignment.topCenter, children: [
            Positioned(
              top: 15,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 45,
              ),
            ),
            Positioned(
              top: 70,
              right: 90,
              child: IconButton(
                onPressed: () async {
                  await pickImage(); // 이미지 선택
                },
                icon: Icon(Icons.add_a_photo_outlined),
              ),
            ),
            Positioned(
              top: 130,
              left: 5,
              child: Text(
                'Edit Message',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 150,
              child: Container(
                width: 280,
                child: TextFormField(
                  controller: _statusMessageController, // Attach the controller
                  decoration: InputDecoration(
                      hintText: '상태메세지를 입력하세요.',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      )),
                ),
              ),
            )
          ]),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            // Handle the username update logic here
            // Perform the update logic
            if (_imageFile == null && _statusMessageController.text.isEmpty) {
              // 입력값이 아무것도 없으면 pop
              Navigator.of(context).pop();
            } else if (_imageFile == null &&
                _statusMessageController.text.isNotEmpty) {
              // message만 작성되어 있으면 메시지만 저장
              await updateStatusMessage(_statusMessageController.text);
              _showSnackBar('상태 메시지가 수정되었습니다.');
              Navigator.of(context).pop();
            } else if (_imageFile != null &&
                _statusMessageController.text.isEmpty) {
              // Image만 Null이 아니면 이미지만 저장
              await uploadProfileImage(_imageFile!);
              _showSnackBar('프로필 이미지가 수정되었습니다.');
              Navigator.of(context).pop();
            } else {
              // 둘 다 저장
              await uploadProfileData(
                  _imageFile, _statusMessageController.text);

              _showSnackBar('프로필이 수정되었습니다.');
              Navigator.of(context).pop();
            }
          },
          child: Text(
            'Save',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
