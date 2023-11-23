import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';

class MyPageFriendListWidget extends StatefulWidget {

  const MyPageFriendListWidget(
      {super.key});

  @override
  State<MyPageFriendListWidget> createState() => _MyPageFriendListWidgetState();
}

class _MyPageFriendListWidgetState extends State<MyPageFriendListWidget> {
  @override

  Widget _listbox(friend) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))
      ),
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
                    DataVO.myUserData.friend.toString(),
                    style: TextStyle(
                        fontSize: 20
                    ),
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
                //실행할 작업 추가
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
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: DataVO.myUserData.friend.length, // 친구 수 만큼 지정될 것
      itemBuilder: (BuildContext context, int index) {
        return _listbox(
          DataVO.myUserData.friend// 필요한 데이터 추가
        );
      },
    );
  }
}
