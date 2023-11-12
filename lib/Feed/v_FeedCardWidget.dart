import 'dart:math';
import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';

class FeedPageWidget extends StatefulWidget {
  int number;
  List<FeedDataVO> FollowedFeeds;
  FeedPageWidget({required this.number, required this.FollowedFeeds});

  @override
  State<FeedPageWidget> createState() => _PostCardState();
}

class _PostCardState extends State<FeedPageWidget> {
  List<String> testImageList = [
    'https://cdn.fourfourtwo.co.kr/news/photo/202209/19430_41368_1537.jpg',
    'https://thumb.mt.co.kr/06/2020/07/2020071219524948198_1.jpg/dims/optimize/',
    'https://cdnimage.dailian.co.kr/news/202203/news_1647507028_1094233_m_1.jpeg',
    'https://image.news1.kr/system/photos/2022/10/3/5608418/article.jpg/dims/quality/80/optimize',
    'data:image/jpeg;base64,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'
  ];
  bool isFavorite = false; //좋아요 체크를 위한 변수 선언

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      'https://i.namu.wiki/i/AIWsICElbpxe8dupLfOGWKIuPAOZcPTyZosFComIBmsN_ViJ7rP9HEqF_pKM0tllaEciKIEhtZDV0LMcodz8h_-GsCYje9YB_5eBSrJAE8nQsBh1IVPRG2y-Oab3JJZeciEfTjHQVp61BA3DMxgsnQ.webp'),
                ),
                SizedBox(
                  width: 10,
                ),
                Text('userName'),
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
                    testImageList[Random().nextInt(5)],
                    fit: BoxFit.cover,
                    width:
                        MediaQuery.of(context).size.width - 100, // 조정된 이미지의 폭
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
                '''dashjdfkghjkfadsjghkfasdgjkhㅁㄴㅇ라ㅏㅗㅁ알ㅇㅁ남ㅇ남ㅇㄴㄻㅇ나ㅏㄴ어''',
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
                      '#홀란드',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  child: TextButton(
                    onPressed: () {
                      // 눌렀을 때 수행할 작업
                    },
                    child: Text(
                      '#잘생김',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
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
    );
  }
}
