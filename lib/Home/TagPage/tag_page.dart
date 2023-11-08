

import 'package:flutter/material.dart';

class TagPageWidget extends StatefulWidget {
  TagPageWidget({Key? key}) : super(key: key);

  @override
  State<TagPageWidget> createState() => TagPageWidgetState();
}
class TagPageWidgetState extends State<TagPageWidget> {
  List<String> contentTitles = [];
  List<String> contentDescriptions = [];
  List<String> contentTimes = [];
  List<String> contentSources = [];



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

                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요',
                    labelText: '컨텐츠 검색',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(

                onPressed: () {  },
                child: Text('검색'),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildContentItem(String title, String description, String time, String source, bool isFavorite, int index) {
    return GestureDetector(
      onTap: () {
        // 컨텐츠 클릭 시 상세 정보 페이지 이동
      },
      child: Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 3.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(description),
                  Text(time),
                  Text(source),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}

