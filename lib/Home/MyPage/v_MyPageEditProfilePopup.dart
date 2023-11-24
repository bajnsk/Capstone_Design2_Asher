import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';

class MyPageEditProfilePopup extends StatefulWidget {
  const MyPageEditProfilePopup({super.key});

  @override
  State<MyPageEditProfilePopup> createState() => _MyPageEditProfilePopupState();
}

class _MyPageEditProfilePopupState extends State<MyPageEditProfilePopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profile',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: 300,
          height: 200,
          child: Stack(
              alignment: Alignment.topCenter,
              children: [
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
                    onPressed: () {
                      //작동할 것 추가
                    },
                    icon: Icon(
                        Icons.add_a_photo_outlined
                    ),
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
                      decoration: InputDecoration(
                        hintText: '상태메세지를 입력하세요.',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        )
                      ),
                    ),
                  ),
                )
              ]
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Handle the username update logic here
            // Perform the update logic


            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Save',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
