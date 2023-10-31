import '../Firebase_LogIn.dart';
import 'package:capstone/Firebase_LogIn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'HomeScreen.dart';



class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      label: '홈',
      icon: Icon(Icons.home_filled),
    ),
    BottomNavigationBarItem(
      label: '검색',
      icon: Icon(Icons.search),
    ),
    BottomNavigationBarItem(
      label: '마이페이지',
      icon: Icon(Icons.list_alt),
    ),
  ];
  List pages=[
    HomeScreen(),
    Container(
      child: Center(
        child: Text("검색페이지"),
      ),
    ),
    Container(
      child: Center(
        child: Text("마이페이지"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            _selectedIndex = index;
          });
        },

        showSelectedLabels: false,
        showUnselectedLabels: false,

        items: bottomItems,
      ),
      body: pages[_selectedIndex],
      /*
      ElevatedButton(
        onPressed: () {
          // 버튼을 누를 때 signOut 함수를 호출
          AuthFunctions.signOut().then((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AuthWidget()),
            );
          });
        },
        child: Text('Sign Out'),
      ),

       */
    );
  }
}