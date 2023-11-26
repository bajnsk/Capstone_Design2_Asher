import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowFriendListWidget extends StatefulWidget {
  const FollowFriendListWidget({super.key});

  @override
  State<FollowFriendListWidget> createState() => _FollowFriendListWidgetState();
}

class _FollowFriendListWidgetState extends State<FollowFriendListWidget> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<bool> isFriendSelectedList = List.filled(DataVO.myUserData.friend.length, false);

  Widget _followlistbox(String friendUid, int index) {

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(friendUid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('오류: ${snapshot.error}');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('사용자를 찾을 수 없습니다');
        }

        var friendData = snapshot.data!.data() as Map<String, dynamic>;

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
                        friendData['name'],
                        style: TextStyle(fontSize: 20),
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
                          });
                          // 체크박스 상태가 변경될 때 실행되는 작업 추가
                        },
                        activeColor: Colors.white,
                        checkColor: Colors.black,
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: DataVO.myUserData.friend.length,
      itemBuilder: (BuildContext context, int index) {
        return _followlistbox(DataVO.myUserData.friend[index], index);
      },
    );
  }
}