import 'package:flutter/material.dart';

class MyPageWidget extends StatefulWidget {
  const MyPageWidget({super.key});

  @override
  State<MyPageWidget> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageWidget> with TickerProviderStateMixin{
  late TabController tabController;
  @override
  void initState(){
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  // 사용자의 친구 수 게시글 수 좋아요 누른 수를 나타내기 위한 위젯
  Widget _statisticsOne(String title, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        )
      ],
    );
  }

  //프로필 수정 및 친구추가 위젯
  Widget _editprofile(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 25),
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
                    )
                ),
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
          const SizedBox(width: 8,),
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
              child: Icon(
                  Icons.person_add_alt_1
              ),
            ),
          )
        ],
      ),
    );
  }

  //사용자 정보 위젯
  Widget _information(){
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage('https://i.namu.wiki/i/AIWsICElbpxe8dupLfOGWKIuPAOZcPTyZosFComIBmsN_ViJ7rP9HEqF_pKM0tllaEciKIEhtZDV0LMcodz8h_-GsCYje9YB_5eBSrJAE8nQsBh1IVPRG2y-Oab3JJZeciEfTjHQVp61BA3DMxgsnQ.webp'),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statisticsOne('Friends',15),
                    _statisticsOne('Feeds',15),
                    _statisticsOne('Likes',15),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Text(
            'Hi',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          )
        ],
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
  Widget _tabview(){
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 100,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            print('Item $index tapped');//눌렀을 때 작동할 코드 추가
          },
          child: Container(
            color: Colors.grey,
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
