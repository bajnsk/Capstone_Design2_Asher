import 'package:capstone/Home/Feed/v_DetailPageWidget.dart';
import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';
import 'package:capstone/main.dart';

class FeedCardWidget extends StatefulWidget {
  final List<FeedDataVO> FollowedFeeds;
  final FeedDataVO feedData;
  final int index;
  FeedCardWidget(
      {super.key,
      required this.FollowedFeeds,
      required this.feedData,
      required this.index});

  @override
  State<FeedCardWidget> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCardWidget> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    FeedDataVO feedData = widget.FollowedFeeds[widget.index];
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아바타 + 이름 컨테이너
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
                  onTap: () {
                    // Add the action for the more_vert icon
                  },
                  child: Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          // 태그 컨테이너
          Container(
            padding: EdgeInsets.only(left: 50),
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
          // 사진 컨테이너
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPageWidget(
                    feedData: feedData,
                  ),
                ),
              );
            },
            child: Container(
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
          ),
          // 본문 컨테이너
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPageWidget(
                    feedData: feedData,
                  ),
                ),
              );
            },
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
          // 작성 날짜 및 마음, 댓글, 리컨텐츠 컨테이너
          Container(
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
                        // Add the action for the favorite icon
                      },
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(Icons.favorite_border),
                      ),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
