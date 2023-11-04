import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              style: GoogleFonts.bebasNeue(
                fontSize: 30,
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
            onPressed: () {
              // 버튼을 눌렀을 때 수행할 동작 추가할 것
            },
            icon: Icon(Icons.notifications_none, color: Colors.black, size: 30),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () {
              // 버튼을 눌렀을 때 수행할 동작 추가할 것
            },
            icon: Icon(Icons.mail_outline, color: Colors.black, size: 30),
          ),
        ),
      ],
    );
  }
}


