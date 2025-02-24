import 'dart:math';

import 'package:capstone/Home/MyPage/v_MyPage.dart';
import 'package:capstone/Home/MyPage/EditProfilePopup/v_MyPageEditProfilePopup.dart';
import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';
import '../../DB/Feed_Geneator/feed_generator.dart';
import '../../main.dart';
import '../DetailPage/v_DetailPageWidget.dart';
import 'package:capstone/Home/MyPage/AddFriendPopup/v_MyPageAddFriendPopup.dart';
import 'package:capstone/Home/MyPage/FriendList/v_MyPageFriendList.dart';

import 'c_MyPageController.dart';

class MyPageWidget extends StatefulWidget {
  final List<FeedDataVO> myFeedsList;
  final List<FeedDataVO> likeFeedsList;
  final FeedDataVO feedData;
  final int index;

  MyPageWidget({
    super.key,
    required this.myFeedsList,
    required this.feedData,
    required this.index,
    required this.likeFeedsList,
  });

  @override
  State<MyPageWidget> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageWidget>
    with TickerProviderStateMixin {
  late TabController tabController;

  // TextEditingController _controller = TextEditingController();
  late bool isFavorite;
  late String imageURL;
  late String userStatus;

  late int FriendLength;
  late int FeedsLength;
  late int LikesLength;

  void onFriendAdded() {
    print('헤헤헤헤ㅔ헤헤');
    setState(() {
      MyPageWidgetState().initState();
      print('됐냐?');
    });
  }

  Future<void> getUserImage() async {
    imageURL = MyController.getUserProfileImage();
  }

  Future<void> getUserStatus() async {
    userStatus = MyController.getUserStatusMessage();
  }

  @override
  void initState() {
    getUserImage();
    getUserStatus();
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    FriendLength = DataVO.myUserData.friend.length;
    FeedsLength = DataVO.myUserData.myFeed.length;
    LikesLength = DataVO.myUserData.likeFeed.length;
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
                setState(
                  () {
                    //누를 시 수행할 작업 추가
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyPageEditProfilePopup(); // 위에서 정의한 팝업 위젯
                        });
                  },
                );
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MyPageAddFriendPopup(onFriendAdded: onFriendAdded);
                },
              );
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
    FeedDataVO feedData = widget.myFeedsList[widget.index];
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundImage: NetworkImage(imageURL),
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
                            userStatus, // Replace with actual text
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
                        //연필 아이콘 누르면 피드 작성 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedGenerator()),
                        );
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
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyPageFriendList(),
                            ),
                          );
                        },
                        child: _statisticsOne(FriendLength, 'Friends')),
                    _statisticsOne(FeedsLength, 'Feeds'),
                    _statisticsOne(LikesLength, 'Likes'),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 1200, // 원하는 높이로 조절
          child: TabBarView(
            controller: tabController,
            children: [
              _tabViewForMyFeeds(),
              _tabViewForLikeFeeds(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _information(),
        ),
        SliverToBoxAdapter(
          child: _editprofile(),
        ),
        SliverToBoxAdapter(
          child: _tabmenu(),
        ),
        SliverToBoxAdapter(
          child: _tabview(),
        ),
      ],
    );
  }

  Widget _tabViewForMyFeeds() {
    if (widget.myFeedsList.isEmpty) {
      return Center(
        child: Text('피드가 없습니다.'),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.myFeedsList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        FeedDataVO feedData = widget.myFeedsList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPageWidget(
                  feedData: feedData,
                  isFavorite: false,
                ),
              ),
            );
          },
          child: Stack(children: [
            Container(
              alignment: Alignment.center,
              child: ClipRRect(
                child: Image.network(feedData.image[0]),
              ),
            ),
            feedData.reContentId != null
                ? Positioned(
                    left: 1,
                    top: 5,
                    child: Icon(
                      Icons.attach_file,
                      color: Colors.grey,
                      size: 20,
                    ),
                  )
                : Container(),
          ]),
        );
      },
    );
  }

  Widget _tabViewForLikeFeeds() {
    if (widget.likeFeedsList.isEmpty) {
      return Center(
        child: Text('피드가 없습니다.'),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.likeFeedsList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        FeedDataVO feedData = widget.likeFeedsList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPageWidget(
                  feedData: feedData,
                  isFavorite: true,
                ),
              ),
            );
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
}
