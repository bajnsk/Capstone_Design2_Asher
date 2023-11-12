import 'package:flutter/material.dart';
import 'v_MyPageWidget.dart';

class MyPageView extends StatefulWidget {
  MyPageView({Key? key}) : super(key: key);

  @override
  State<MyPageView> createState() => MyPageWidgetState();
}
class MyPageWidgetState extends State<MyPageView> {
  @override
  void initState() {
    super.initState();
    // Initially, show all items

  }
  @override
  Widget build(BuildContext context) {
    return MyPageWidget();
  }
}
