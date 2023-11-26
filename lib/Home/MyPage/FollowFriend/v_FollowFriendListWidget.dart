import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'c_FollowFriendController.dart';

class FollowFriendListWidget extends StatefulWidget {
  const FollowFriendListWidget({Key? key}) : super(key: key);

  @override
  State<FollowFriendListWidget> createState() => _FollowFriendListWidgetState();
}

class _FollowFriendListWidgetState extends State<FollowFriendListWidget> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, String> friendNameCache = {}; // Cache to store friend names
  List<bool> isFriendSelectedList =
      List.filled(DataVO.myUserData.friend.length, false);

  List<String> selectedFriendUids = [];

  Future<String> getFriendName(String friendUid) async {
    // Check if friend name is already in the cache
    if (friendNameCache.containsKey(friendUid)) {
      return friendNameCache[friendUid]!;
    }

    // If not in cache, fetch friend name from Firestore
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(friendUid).get();

    if (snapshot.exists) {
      String friendName = snapshot['name'];
      // Cache the friend name
      friendNameCache[friendUid] = friendName;
      return friendName;
    } else {
      return '사용자를 찾을 수 없습니다';
    }
  }

  Widget _followlistbox(String friendUid, int index) {
    return FutureBuilder<String>(
      future: getFriendName(friendUid),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
          );
        }

        if (snapshot.hasError) {
          return Text('오류: ${snapshot.error}');
        }

        String friendName = snapshot.data ?? '사용자를 찾을 수 없습니다';

        return Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  width: 200,
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 18,
                      ),
                      Text(
                        friendName,
                        style: GoogleFonts.notoSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Transform.scale(
                    scale: 1.4,
                    child: Checkbox(
                      value: isFriendSelectedList[index],
                      onChanged: (bool? value) {
                        setState(() {
                          isFriendSelectedList[index] = value ?? false;
                          if (value ?? false) {
                            selectedFriendUids.add(friendUid);
                          } else {
                            selectedFriendUids.remove(friendUid);
                          }
                        });
                      },
                      activeColor:
                          Colors.grey[300], // Adjust the checkbox colors
                      checkColor: Colors.black,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onFeedToFriendPressed() async {
    if (selectedFriendUids.isNotEmpty) {
      // Follow the feed to selected friends
      await FollowFriendController().followToFriend(selectedFriendUids);

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('피드가 친구에게 팔로우 되었습니다.'),
          duration: Duration(seconds: 2),
        ),
      );

      // Go back to the previous screen
      Navigator.of(context).pop();
    } else {
      // If no friends are selected, show a warning message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('친구를 선택해주세요.'),
          duration: Duration(seconds: 2),
        ),
      );
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
        title: Text('이 피드를 보여줄 친구 선택'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: DataVO.myUserData.friend.length,
              itemBuilder: (BuildContext context, int index) {
                return _followlistbox(DataVO.myUserData.friend[index], index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onFeedToFriendPressed,
              child: Text(
                'Feed To Friend',
                style: GoogleFonts.notoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
