import 'package:capstone/Home/DetailPage/v_RecontentsDetailPageWidget.dart';
import 'package:capstone/Home/FeedPage//c_FeedPageController.dart';
import 'package:capstone/Home/DetailPage/v_DetailPageWidget.dart';
import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';
import 'package:capstone/main.dart';
import 'package:like_button/like_button.dart';

class FeedCardWidget extends StatefulWidget {
  final List<FeedDataVO> FollowedFeeds;
  final FeedDataVO feedData;
  final int index;

  FeedCardWidget({
    super.key,
    required this.FollowedFeeds,
    required this.feedData,
    required this.index,
  });

  @override
  State<FeedCardWidget> createState() => FeedCardState();
}

class FeedCardState extends State<FeedCardWidget> {
  late bool isFavorite;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      FeedDataVO feedData = widget.FollowedFeeds[widget.index];
      isFavorite = DataVO.myUserData.likeFeed.contains(feedData.feedId);
    });
  }

  @override
  Widget build(BuildContext context) {
    FeedDataVO feedData = widget.FollowedFeeds[widget.index];
    String date = FeedTypeController.internal().makeTimeTodate(feedData);

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필과 유저네임 컨테이너
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
                    feedData.userProfile,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(feedData.userName),
              ],
            ),
          ),
          // 날짜 컨테이너
          Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Text(
              date,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          // 사진 컨테이너
          Stack(children: [
            feedData.reContentId != null
                ? Positioned(
                    top: 20,
                    left: 10,
                    child: Icon(Icons.attach_file),
                  )
                : Container(),
            GestureDetector(
              onTap: () async {
                if (widget.feedData.reContentId == null) {
                  var returnedValue = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPageWidget(
                        feedData: feedData,
                        isFavorite: isFavorite,
                      ),
                    ),
                  );
                  if (returnedValue != null && returnedValue is bool) {
                    setState(() {
                      isFavorite = returnedValue;
                    });
                  }
                } else {
                  var returnedValue = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecontentsDetailPageWidget(
                              feedData: feedData,
                              isFavorite: isFavorite,
                            )),
                  );
                  if (returnedValue != null && returnedValue is bool) {
                    setState(() {
                      isFavorite = returnedValue;
                    });
                  }
                }
              },
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Stack(alignment: Alignment.topRight, children: [
                    Container(
                      margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                      width: MediaQuery.of(context).size.width - 100,
                      height: 230,
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
            ),
          ]),
          // 본문 컨테이너
          GestureDetector(
            onTap: () async {
              if (widget.feedData.reContentId == null) {
                var returnedValue = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPageWidget(
                      feedData: feedData,
                      isFavorite: isFavorite,
                    ),
                  ),
                );
                if (returnedValue != null && returnedValue is bool) {
                  setState(() {
                    isFavorite = returnedValue;
                  });
                }
              } else {
                var returnedValue = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecontentsDetailPageWidget(
                            feedData: feedData,
                            isFavorite: isFavorite,
                          )),
                );
                if (returnedValue != null && returnedValue is bool) {
                  setState(() {
                    isFavorite = returnedValue;
                  });
                }
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Text(
                feedData.context_text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          // 태그 컨테이너
          Container(
            padding: EdgeInsets.only(left: 50, top: 10),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                for (String tag in feedData.tag)
                  TextButton(
                    onPressed: () {
                      // Add the action for each tag
                    },
                    child: Text(
                      tag,
                      style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                    ),
                  ),
              ],
            ),
          ),
          // 작성 날짜 및 마음, 댓글, 리컨텐츠 컨테이너
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeButton(
                      isLiked: isFavorite,
                      onTap: (bool isLiked) {
                        // 하트 버튼을 눌렀을 때
                        setState(() {
                          isFavorite = !isFavorite;
                          // DataVO.myUserData.likeFeeds 업데이트
                          if (isFavorite) {
                            DataVO.myUserData.likeFeed.add(feedData.feedId);
                            FeedTypeController.instance
                                .likeFeedToFirebase(feedData);
                          } else {
                            DataVO.myUserData.likeFeed.remove(feedData.feedId);
                            FeedTypeController.instance
                                .unlikeFeedFromFirebase(feedData);
                          }
                        });
                        return Future.value(!isLiked);
                      },
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        // Add the action for the message icon
                      },
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(Icons.message),
                      ),
                    ),
                  ],
                ),
                // Spacer 추가
                Spacer(),
                InkWell(
                  onTap: () {
                    logger.d(feedData);
                    // Add the action for the repeat icon
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Icon(Icons.repeat),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
