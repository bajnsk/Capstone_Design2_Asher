import 'package:flutter/material.dart';

class RecontentsDetailPageWidget extends StatefulWidget {
  const RecontentsDetailPageWidget({super.key});

  @override
  State<RecontentsDetailPageWidget> createState() => _RecontentsDetailPageWidgetState();
}

class _RecontentsDetailPageWidgetState extends State<RecontentsDetailPageWidget> {
  @override
  Widget build(BuildContext context) {
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
            //리컨텐츠된 피드 컨테이너
            Container(
              width: MediaQuery.of(context).size.width,
              height: null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //타임 스탬프 컨테이너
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Text(
                      'date',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  //사진 컨테이너
                  Container(
                    margin: EdgeInsets.only(top: 10,left: 25),
                    width: MediaQuery.of(context).size.width - 50,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey
                    ),
                  ),
                  SizedBox(height: 15,),
                  //본문 컨테이너
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    margin: EdgeInsets.only(left: 25),
                    child: Text(
                        '본문텍스트'
                    ),
                  ),
                  SizedBox(height: 15,),
                  //태그 컨테이너
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    margin: EdgeInsets.only(left: 25),
                    child: Text(
                        '태그'
                    ),
                  ),
                ],
              ),
            ),

            //리컨텐츠 아이콘
            Icon(
              Icons.attach_file,
              color: Colors.grey.withOpacity(0.7),
              size: 40,
            ),
            SizedBox(height: 10,),

            //리컨텐츠해 새로 작성된 피드 컨테이너
            Container(
              width: MediaQuery.of(context).size.width,
              height: null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //프로필 및 유저이름 컨테이너
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
                        Text('feedData.userName'),
                        Spacer(), // 여기에 Spacer 추가
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
                  //새로 생성된 타임스탬프 컨테이너
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30,top: 5),
                    child: Text(
                      'date',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  //새로 생성된 사진 컨테이너
                  Container(
                    margin: EdgeInsets.only(top: 10,left: 25),
                    width: MediaQuery.of(context).size.width - 50,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey
                    ),
                  ),
                  SizedBox(height: 15,),
                  //새로 생성된 본문 컨테이너
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    margin: EdgeInsets.only(left: 25),
                    child: Text(
                        '본문텍스트'
                    ),
                  ),
                  SizedBox(height: 15,),
                  //새로 생성된 태그 컨테이너
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    margin: EdgeInsets.only(left: 25),
                    child: Text(
                        '태그'
                    ),
                  ),
                  SizedBox(height: 15,),
                  //하트 및 각종 아이콘 컨테이너
                  Container(
                    margin: EdgeInsets.only(left: 25,right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            /*
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

                             */
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
                  SizedBox(height: 15,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
