import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';

import '../Feed/v_DetailPageWidget.dart';

class MyPageWidget extends StatefulWidget {
  final List<FeedDataVO> MyFeedsList;
  final FeedDataVO feedData;
  final int index;

  MyPageWidget(
      {super.key,
      required this.MyFeedsList,
      required this.feedData,
      required this.index});

  @override
  State<MyPageWidget> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageWidget>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  // 사용자의 친구 수 게시글 수 좋아요 누른 수를 나타내기 위한 위젯
  Widget _statisticsOne(int value, String title) {
    return Row(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        )
      ],
    );
  }

  //프로필 수정 및 친구추가 위젯
  Widget _editprofile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                //누를 시 수행할 작업 추가
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                child: const Text(
                  '프로필 수정',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          InkWell(
            onTap: () {
              //누를 시 수행할 작업 추가
            },
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Icon(Icons.person_add_alt_1),
            ),
          )
        ],
      ),
    );
  }

  // 사용자 정보 위젯
  Widget _information() {
    FeedDataVO feedData = widget.MyFeedsList[widget.index];
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundImage: NetworkImage(
                  'https://i.namu.wiki/i/AIWsICElbpxe8dupLfOGWKIuPAOZcPTyZosFComIBmsN_ViJ7rP9HEqF_pKM0tllaEciKIEhtZDV0LMcodz8h_-GsCYje9YB_5eBSrJAE8nQsBh1IVPRG2y-Oab3JJZeciEfTjHQVp61BA3DMxgsnQ.webp'),
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feedData
                                .userName, // Replace with the actual username
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Some additional text', // Replace with actual text
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        //버튼 누를시 작동할 것 추가
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Icon(
                          Icons.edit, // Replace with the icon you want
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statisticsOne(15, 'Friends'),
                    _statisticsOne(15, 'Feeds'),
                    _statisticsOne(15, 'Likes'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //탭 메뉴 위젯
  Widget _tabmenu() {
    return TabBar(
      controller: tabController,
      indicatorColor: Colors.black,
      indicatorWeight: 1,
      tabs: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Icon(
            Icons.grid_on_outlined,
            color: Colors.black,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Icon(
            Icons.thumb_up_alt_rounded,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  //탭뷰 위젯
  Widget _tabview() {
    if (widget.MyFeedsList.isEmpty) {
      return Center(
        child: Text('No feeds available'),
      );
    }
    FeedDataVO feedData = widget.MyFeedsList[widget.index];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.MyFeedsList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPageWidget(
                  feedData: feedData,
                ),
              ),
            ); //눌렀을 때 작동할 코드 추가
          },
          child: Container(
            child: ClipRRect(
              child: Image.network(feedData.image[0]),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _information(),
          _editprofile(),
          _tabmenu(),
          _tabview(),
        ],
      ),
    );
  }
}
