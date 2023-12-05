import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../DataVO/model.dart';
import '../DetailPage/v_TagDetailPageWidget.dart';

class TagPageWidget extends StatefulWidget {
  TagPageWidget({Key? key}) : super(key: key);

  @override
  State<TagPageWidget> createState() => TagPageWidgetState();
}

class TagPageWidgetState extends State<TagPageWidget> {
  List<FeedDataVO> tagFeedList = DataVO.feedData; // Use feedData directly

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Center(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '검색할 태그를 입력하시오.',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      //수행할 작업 추가
                    },
                    icon: Icon(
                      CupertinoIcons.search,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.grey,
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Text('태그 구독? 추천? 임시 컨테이너'),
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: tagFeedList.length, // Use tagFeedList.length
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              FeedDataVO feed =
                  tagFeedList[index]; // Get feed at the current index

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TagDetailPageWidget(feedData: tagFeedList[index]),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 130,
                        child: Image.network(
                          tagFeedList[index].image[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 45,
                        padding: EdgeInsets.only(left: 10,right: 10,top: 3),
                        child: Text(tagFeedList[index].context_text),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Row(children: [
                            for (String tag in tagFeedList[index].tag)
                              Text(tag),
                          ]))
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
