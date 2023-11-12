import 'package:flutter/material.dart';
import 'v_my_page.dart';

class MyPageWidget extends StatefulWidget {
  MyPageWidget({Key? key}) : super(key: key);

  @override
  State<MyPageWidget> createState() => MyPageWidgetState();
}
class MyPageWidgetState extends State<MyPageWidget> {
  @override
  void initState() {
    super.initState();
    // Initially, show all items

  }
  @override
  Widget build(BuildContext context) {
    return MyPageView();
  }
}
