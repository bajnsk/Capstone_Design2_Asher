import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:capstone/DB/friends_generator.dart';

class MyPageAddFriendPopup extends StatefulWidget {
  const MyPageAddFriendPopup({super.key, required this.onFriendAdded});
  final VoidCallback onFriendAdded;

  @override
  State<MyPageAddFriendPopup> createState() => _MyPagePopupState();
}

class _MyPagePopupState extends State<MyPageAddFriendPopup> {
  TextEditingController _usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FriendController _friendController = FriendController();
  late String uid;

  @override
  void initState() {
    super.initState();
    getUserUid();
  }

  Future<void> getUserUid() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    }
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Friend',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: Container(
        width: 300,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  hintText: '친구추가할 Uid를 입력해주세요.',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  )),
              cursorColor: Colors.black,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Your Uid',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            SelectableText(
              uid,
              style: TextStyle(fontSize: 16),
            )
          ],
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
          onPressed: () {
            // Handle the username update logic here
            _friendController.addFriendByName(_usernameController.text);
            // Perform the update logic
            widget.onFriendAdded();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'Add',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
