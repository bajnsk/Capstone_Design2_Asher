// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../MainPage/main_page.dart';
//
// class AsherBottomNavigationBar extends MenuWidget implements PreferredSizeWidget {
//   int selectedIndex;
//   void Function(int index) selectMenu;
//
//   AsherBottomNavigationBar(this.selectedIndex, this.selectMenu);
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: BottomNavigationBar(
//         backgroundColor: Colors.grey[300], // 배경 색상을 회색(Shades of Grey 300)으로 설정
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.image),
//             label: 'main',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.content_paste),
//             label: 'tag',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'my',
//           ),
//         ],
//         currentIndex: selectedIndex,
//         onTap: selectMenu,
//         selectedItemColor: Colors.black, // 선택된 항목의 폰트 색상을 검정으로 설정
//         unselectedItemColor: Colors.grey, // 선택되지 않은 항목의 폰트 색상을 회색으로 설정
//         selectedLabelStyle: GoogleFonts.bebasNeue(fontSize: 16, fontWeight: FontWeight.bold), // 선택된 항목의 폰트 스타일 설정
//         unselectedLabelStyle: GoogleFonts.bebasNeue(fontSize: 16), // 선택되지 않은 항목의 폰트 스타일 설정
//       ),
//     );
//   }
// }
