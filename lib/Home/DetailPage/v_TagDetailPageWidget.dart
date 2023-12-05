import 'package:capstone/DataVO/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../FeedPage/c_FeedPageController.dart';

class TagDetailPageWidget extends StatefulWidget {
  const TagDetailPageWidget({Key? key, required this.feedData})
      : super(key: key);

  final FeedDataVO feedData;

  @override
  State<TagDetailPageWidget> createState() => _TagDetailPageWidgetState();
}

class _TagDetailPageWidgetState extends State<TagDetailPageWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    FeedDataVO feedData = widget.feedData;
    String date = FeedTypeController.internal()
        .makeTimeTodate(widget.feedData)
        .toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('태그 페이지 피드'),
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            // 날짜 컨테이너
            Container(
              padding: EdgeInsets.only(top: 10, left: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                date, // TODO: FeedDataVO에서 날짜 데이터를 가져와서 표시
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            // 사진 컨테이너
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Stack(alignment: Alignment.topRight, children: [
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: PageView.builder(
                          itemCount: feedData.image.length,
                          onPageChanged: (value) {
                            setState(() {
                              currentPageIndex = value;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              feedData.image.isNotEmpty &&
                                      feedData.image.length > 0
                                  ? feedData.image[index]
                                  : 'https://firebasestorage.googleapis.com/v0/b/capstone2-1ad1d.appspot.com/o/smile%20pepe.png?alt=media&token=2240d1b9-b8cd-472a-81b8-d4f3be82335b',
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width - 100,
                              height: 280,
                            );
                          }),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      margin: const EdgeInsets.only(top: 20, right: 60),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(500)),
                      child: Text(
                        '${currentPageIndex + 1}/${feedData.image.length}',
                        style: TextStyle(color: Colors.white),
                      )),
                ]),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
              width: MediaQuery.of(context).size.width - 50,
              child: Text(
                widget
                    .feedData.context_text, // TODO: FeedDataVO에서 본문 텍스트 가져와서 표시
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 17),
              ),
            ),
            // 태그 컨테이너
            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 10),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  for (String tag in widget.feedData.tag)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          // Add the action for each tag
                        },
                        child: Text(
                          tag,
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 17),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // 마음, 댁슬, 리컨텐츠 컨테이너
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(CupertinoIcons.heart),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.message)
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.repeat)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
