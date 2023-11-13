import 'package:flutter/material.dart';
import '../../DataVO/model.dart';

class DetailPageWidget extends StatefulWidget {
  final FeedDataVO feedData;

  DetailPageWidget({super.key, required this.feedData});

  @override
  State<DetailPageWidget> createState() => _DetailPageWidgetState();
}

class _DetailPageWidgetState extends State<DetailPageWidget> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    FeedDataVO feedData = widget.feedData;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('이전 페이지'),
      ),
      body: Container(
        child: Column(
          children: [
            //아바타 + 이름 컨테이너
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.7,
                  ),
                  top: BorderSide(
                    color: Colors.grey,
                    width: 0.7,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                      'https://i.namu.wiki/i/AIWsICElbpxe8dupLfOGWKIuPAOZcPTyZosFComIBmsN_ViJ7rP9HEqF_pKM0tllaEciKIEhtZDV0LMcodz8h_-GsCYje9YB_5eBSrJAE8nQsBh1IVPRG2y-Oab3JJZeciEfTjHQVp61BA3DMxgsnQ.webp',
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(feedData.userName),
                  Expanded(
                    child: Container(),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Icon(Icons.more_vert),
                  )
                ],
              ),
            ),
            //글의 종류 컨테이너
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                left: 50,
                top: 15,
              ),
              child: Text('글의 종류'),
            ),
            //사진 컨테이너
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(left: 50, right: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      feedData.image.isNotEmpty && feedData.image.length > 0
                          ? feedData.image[0]
                          : 'https://firebasestorage.googleapis.com/v0/b/capstone2-1ad1d.appspot.com/o/smile%20pepe.png?alt=media&token=2240d1b9-b8cd-472a-81b8-d4f3be82335b',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width - 100,
                      height: 230,
                    ),
                  ),
                ),
              ),
            ),
            //본문 컨테이너
            Container(
              height: null, // 높이를 자동으로 조절하도록 설정
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Text(
                  feedData.context_text,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            //태그 컨테이너
            Container(
              height: 40,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 50),
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // 눌렀을 때 수행할 작업
                      },
                      child: Text(
                        feedData.tag.isNotEmpty && feedData.tag.length > 0
                            ? feedData.tag[0]
                            : 'tag0',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  // Container(
                  //   child: TextButton(
                  //     onPressed: () {
                  //       // 눌렀을 때 수행할 작업
                  //     },
                  //     child: Text(
                  //       feedData.tag.isNotEmpty && feedData.tag.length > 0
                  //           ? feedData.tag[1]
                  //           : 'tag1',
                  //       style: TextStyle(color: Colors.grey),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            //작성 날짜 및 마음, 댓글, 리컨텐츠 컨테이너
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        '23/09/15 Fri xx:xx',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3.0), // 간격 조절
                            child: isFavorite
                                ? Icon(Icons.favorite, color: Colors.red)
                                : Icon(Icons.favorite_border),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // 메시지 버튼이 눌렸을 때 수행할 작업 추가
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3.0), // 간격 조절
                            child: Icon(Icons.message),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // 반복 버튼이 눌렸을 때 수행할 작업 추가
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3.0), // 간격 조절
                            child: Icon(Icons.repeat),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
