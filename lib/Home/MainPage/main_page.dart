


import 'package:flutter/material.dart';

class MainPageWidget extends StatefulWidget {
  MainPageWidget({Key? key}) : super(key: key);

  @override
  State<MainPageWidget> createState() {
    return MainPageWidgetState();
  }
}
class MainPageWidgetState extends State<MainPageWidget> {

  List<String> imageUrls = [];
  List<String> imageTittle = [];
  List<String> imageDates = [];
  List<String> imageSources = [];
  String apiKey = '894702417e89ef951cd0d79fabd04620'; // 본인의 카카오 API 키로 대체
  TextEditingController searchController = TextEditingController();


  // 관심 버튼 처리

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요',
                    labelText: '이미지 검색',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {  }, child: null,
              ),
            ],
          ),
        ),
      ],
    );
  }

}
