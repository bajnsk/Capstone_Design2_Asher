// import 'package:capstone/Home/MyPage/FollowFriend/v_FollowFriendList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../DB/Feed_Geneator/feed_generator.dart';

class AsherAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 20), // 왼쪽 여백 추가
        child: Row(
          children: [
            Text(
              'Asher',
              style: GoogleFonts.nanumPenScript(
                fontSize: 60,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[300],
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none, color: Colors.black, size: 30),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () {
              // 버튼을 눌렀을 때 수행할 동작 추가할 것
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedGenerator()),
              );
            },
            icon: Icon(Icons.mail_outline, color: Colors.black, size: 30),
          ),
        ),
      ],
    );
  }
}
