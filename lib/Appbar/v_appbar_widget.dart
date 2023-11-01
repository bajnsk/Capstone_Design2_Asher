import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class appbar extends StatefulWidget {
  const appbar({super.key});

  @override
  State<appbar> createState() => _appbarState();
}

class _appbarState extends State<appbar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Asher',
          style: GoogleFonts.bebasNeue(
            fontSize: 30,
            color: Colors.grey[700],
          ),
        ),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black, size: 30),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 40),
            child: IconButton(
              onPressed: () {
                // 버튼을 눌렀을 때 수행할 동작 추가할 것
              },
              icon: Icon(Icons.notifications_none, color: Colors.black, size: 30),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                // 버튼을 눌렀을 때 수행할 동작 추가할 것
              },
              icon: Icon(Icons.mail_outline, color: Colors.black, size: 30),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('메뉴 항목 1'),
              onTap: () {
                // 메뉴 항목 1이 선택되었을 때 수행할 작업
              },
            ),
            ListTile(
              title: Text('메뉴 항목 2'),
              onTap: () {
                // 메뉴 항목 2가 선택되었을 때 수행할 작업
              },
            ),
            // 추가적인 메뉴 항목들...
          ],
        ),
      ),
    );
  }
}
