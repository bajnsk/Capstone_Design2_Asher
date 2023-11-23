import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPageFriendListWidget extends StatefulWidget {
  const MyPageFriendListWidget({Key? key}) : super(key: key);

  @override
  State<MyPageFriendListWidget> createState() => _MyPageFriendListWidgetState();
}

class _MyPageFriendListWidgetState extends State<MyPageFriendListWidget> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Widget _listbox(String friendUid) {
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
                child: InkWell(
                  onTap: () {
                    // 실행할 작업 추가
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 40,
                      color: Colors.red,
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
        return _listbox(DataVO.myUserData.friend[index]);
      },
    );
  }
}
