import 'package:flutter/material.dart';

class MyPageAddFriendPopup extends StatefulWidget {
  const MyPageAddFriendPopup({super.key});

  @override
  State<MyPageAddFriendPopup> createState() => _MyPagePopupState();
}

class _MyPagePopupState extends State<MyPageAddFriendPopup> {
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Friend',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20
        ),
      ),
      content: Container(
        width: 300,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(hintText: '친구추가할 Uid를 입력해주세요.',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                )
              ),
              cursorColor: Colors.black,
            ),
            SizedBox(height: 20,),
            Text(
              'Your Uid',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            SizedBox(height: 20,),
            SelectableText(
              'asdhfjk',
              style: TextStyle(
                fontSize: 16
              ),
            )
          ],
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
            String newUsername = _usernameController.text;
            // Perform the update logic

            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Add',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
