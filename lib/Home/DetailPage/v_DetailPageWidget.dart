import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import '../../DataVO/model.dart';
import '../../main.dart';
import '../FeedPage/c_FeedPageController.dart';

class DetailPageWidget extends StatefulWidget {
  final FeedDataVO feedData;
  final bool isFavorite;

  DetailPageWidget({
    super.key,
    required this.feedData,
    required this.isFavorite,
  });

  @override
  State<DetailPageWidget> createState() => _DetailPageWidgetState();
}

class _DetailPageWidgetState extends State<DetailPageWidget> {
  late bool isFavorite;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // 전달받은 isFavorite 값으로 초기화합니다.
    isFavorite = DataVO.myUserData.likeFeed.contains(widget.feedData.feedId);
  }

  @override
  Widget build(BuildContext context) {
    FeedDataVO feedData = widget.feedData;
    String date = FeedTypeController.internal().makeTimeTodate(feedData);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(isFavorite);
          },
        ),
      ),
      body: Container(
        child: Column(
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
                      'https://i.namu.wiki/i/AIWsICElbpxe8dupLfOGWKIuPAOZcPTyZosFComIBmsN_ViJ7rP9HEqF_pKM0tllaEciKIEhtZDV0LMcodz8h_-GsCYje9YB_5eBSrJAE8nQsBh1IVPRG2y-Oab3JJZeciEfTjHQVp61BA3DMxgsnQ.webp',
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(feedData.userName),
                  Spacer(), // 여기에 Spacer 추가
                  InkWell(
                    onTap: () {
                      // Add the action for the more_vert icon
                    },
                    child: Icon(Icons.more_vert),
                  ),
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
            // 본문 컨테이너
            Container(
              width: MediaQuery.of(context).size.width - 100,
              padding: EdgeInsets.only(left: 50, right: 50, top: 10),
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
                        style: TextStyle(color: Colors.grey),
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
                            FeedTypeController.instance
                                .reversalLike(feedData, isFavorite);
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
      ),
    );
  }
}
