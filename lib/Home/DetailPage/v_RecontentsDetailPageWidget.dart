import 'package:capstone/DataVO/model.dart';
import 'package:capstone/Home/FeedPage/c_FeedPageController.dart';
import 'package:flutter/material.dart';

class RecontentsDetailPageWidget extends StatefulWidget {
  const RecontentsDetailPageWidget(
      {super.key, required this.feedData, required this.isFavorite});

  final FeedDataVO feedData;
  final bool isFavorite;
  @override
  State<RecontentsDetailPageWidget> createState() =>
      _RecontentsDetailPageWidgetState();
}

class _RecontentsDetailPageWidgetState
    extends State<RecontentsDetailPageWidget> {
  late List<String> recontentsFeedIds = ['null', 'null'];
  late FeedDataVO originalFeed;
  late FeedDataVO recontentsFeed;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    setFeedIds();
    setFeedData();
  }

  void setFeedIds() {
    recontentsFeedIds[0] = widget.feedData.feedId.toString();
    for (FeedDataVO fd in DataVO.feedData) {
      if (fd.feedId == widget.feedData.reContentId) {
        recontentsFeedIds[1] = fd.feedId.toString();
      }
    }
    print('리컨텐츠 아이디들임');
    print(recontentsFeedIds[0]);
    print(recontentsFeedIds[1]);
  }

  void setFeedData() {
    // originalFeed 설정
    recontentsFeed = DataVO.feedData.firstWhere(
      (feed) => feed.feedId.toString() == recontentsFeedIds[0],
      orElse: () => FeedDataVO(
        feedId: 'null',
        userId: 'null',
        reContentId: 'null',
        context_text: 'null',
        image: [],
        makeTime: 'null',
        tag: [],
        userName: 'null',
        userProfile: 'null',
        public: 'null',
      ),
    );

    // recontentsFeed 설정
    originalFeed = DataVO.feedData.firstWhere(
      (feed) => feed.feedId.toString() == recontentsFeedIds[1],
      orElse: () => FeedDataVO(
        feedId: 'null',
        userId: 'null',
        reContentId: 'null',
        context_text: 'null',
        image: [],
        makeTime: 'null',
        tag: [],
        userName: 'null',
        userProfile: 'null',
        public: 'null',
      ),
    );

    // originalFeed과 recontentsFeed를 출력
    print('originalFeed:');
    print(originalFeed);
    print('recontentsFeed:');
    print(recontentsFeed);
  }

  Widget build(BuildContext context) {
    String recontentsFeedMakeTime =
        FeedTypeController.internal().makeTimeTodate(recontentsFeed);
    String originalFeedMakeTime =
        FeedTypeController.internal().makeTimeTodate(originalFeed);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 리컨텐츠된 피드 컨테이너
            Container(
              width: MediaQuery.of(context).size.width,
              height: null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 타임 스탬프 컨테이너
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Text(
                      recontentsFeedMakeTime,
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
                                itemCount: originalFeed.image.length,
                                onPageChanged: (value) {
                                  setState(() {
                                    currentPageIndex = value;
                                  });
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return Image.network(
                                    originalFeed.image.isNotEmpty &&
                                            originalFeed.image.length > 0
                                        ? originalFeed.image[index]
                                        : 'https://firebasestorage.googleapis.com/v0/b/capstone2-1ad1d.appspot.com/o/smile%20pepe.png?alt=media&token=2240d1b9-b8cd-472a-81b8-d4f3be82335b',
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width - 100,
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
                              '${currentPageIndex + 1}/${originalFeed.image.length}',
                              style: TextStyle(color: Colors.white),
                            )),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // 본문 컨테이너
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    margin: EdgeInsets.only(left: 25),
                    child: Text(originalFeed.context_text), // 변경된 부분
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // 태그 컨테이너
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    margin: EdgeInsets.only(left: 25),
                    child: Text(originalFeed.tag
                        .join(', ')
                        .substring(1, originalFeed.tag.join(', ').length - 1)),
                    // 변경된 부분
                  ),
                ],
              ),
            ),

            // 리컨텐츠 아이콘
            Icon(
              Icons.attach_file,
              color: Colors.grey.withOpacity(0.7),
              size: 40,
            ),
            SizedBox(
              height: 10,
            ),

            // 리컨텐츠해 새로 작성된 피드 컨테이너
            Container(
              width: MediaQuery.of(context).size.width,
              height: null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프로필 및 유저이름 컨테이너
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
                          //backgroundImage: NetworkImage(
                          //feedData.userProfile,
                          //),
                        ),
                        SizedBox(width: 10),
                        Text(recontentsFeed.userName), // 변경된 부분
                        Spacer(),
                        InkWell(
                          onTap: () {
                            // Add the action for the more_vert icon
                            //_showMoreMenu(context);
                          },
                          child: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                  // 새로 생성된 타임스탬프 컨테이너
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 5),
                    child: Text(
                      originalFeedMakeTime, // 변경된 부분
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  // 새로 생성된 사진 컨테이너
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
                                itemCount: recontentsFeed.image.length,
                                onPageChanged: (value) {
                                  setState(() {
                                    currentPageIndex = value;
                                  });
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return Image.network(
                                    recontentsFeed.image.isNotEmpty &&
                                            recontentsFeed.image.length > 0
                                        ? recontentsFeed.image[index]
                                        : 'https://firebasestorage.googleapis.com/v0/b/capstone2-1ad1d.appspot.com/o/smile%20pepe.png?alt=media&token=2240d1b9-b8cd-472a-81b8-d4f3be82335b',
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width - 100,
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
                              '${currentPageIndex + 1}/${recontentsFeed.image.length}',
                              style: TextStyle(color: Colors.white),
                            )),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // 새로 생성된 본문 컨테이너
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    margin: EdgeInsets.only(left: 25),
                    child: Text(recontentsFeed.context_text), // 변경된 부분
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // 새로 생성된 태그 컨테이너
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    margin: EdgeInsets.only(left: 25),
                    child: Text(recontentsFeed.tag.join(', ').substring(
                        1, recontentsFeed.tag.join(', ').length - 1)),
                    // 변경된 부분
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // 하트 및 각종 아이콘 컨테이너
                  Container(
                    margin: EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
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
                            //logger.d(feedData);
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
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
