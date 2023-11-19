import 'package:capstone/Appbar/v_appbar_widget.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'MainPage/main_page.dart';
import 'MyPage/v_MyPage.dart';
import 'TagPage/tag_page.dart';
import 'Feed/v_FeedPage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//Home
class HomeWidget extends StatefulWidget {
  @override
  State<HomeWidget> createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  int selectedIndex = 0;
  List<Widget> menuWidgetList = [
    FeedsView(key: UniqueKey()),
    TagPageWidget(key: UniqueKey()),
    MyPageView(key: UniqueKey()),
  ];

  void selectMenu(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AsherAppbar(),
      body: menuWidgetList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300], // 배경 색상을 회색(Shades of Grey 300)으로 설정
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: selectMenu,
        selectedItemColor: Colors.black, // 선택된 항목의 폰트 색상을 검정으로 설정
        unselectedItemColor: Colors.grey, // 선택되지 않은 항목의 폰트 색상을 회색으로 설정
        selectedLabelStyle: GoogleFonts.bebasNeue(
            fontSize: 16, fontWeight: FontWeight.bold), // 선택된 항목의 폰트 스타일 설정
        unselectedLabelStyle:
            GoogleFonts.bebasNeue(fontSize: 16), // 선택되지 않은 항목의 폰트 스타일 설정
      ),
    );
  }
}
