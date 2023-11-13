import 'package:capstone/Home/Feed/v_DetailPageWidget.dart';
import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';

class FeedPageWidget extends StatefulWidget {
  List<FeedDataVO> FollowedFeeds;
  FeedPageWidget({super.key, required this.FollowedFeeds});

  @override
  State<FeedPageWidget> createState() => _PostCardState();
}

class _PostCardState extends State<FeedPageWidget> {
  bool isFavorite = false; //좋아요 체크를 위한 변수 선언

  @override
  Widget build(BuildContext context) {
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
                  // Replace the backgroundImage with your avatar image
                  backgroundImage: NetworkImage(
                    'https://i.namu.wiki/i/AIWsICElbpxe8dupLfOGWKIuPAOZcPTyZosFComIBmsN_ViJ7rP9HEqF_pKM0tllaEciKIEhtZDV0LMcodz8h_-GsCYje9YB_5eBSrJAE8nQsBh1IVPRG2y-Oab3JJZeciEfTjHQVp61BA3DMxgsnQ.webp',
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // Replace 'userName' with the actual username
                Text('userName'),
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
          // 글의 종류 컨테이너
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              left: 50,
              top: 15,
            ),
            // Replace '글의 종류' with the actual content
            child: Text('글의 종류'),
          ),
          // 사진 컨테이너
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPageWidget(),
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
                    // Replace the Image.network with your desired image
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/capstone2-1ad1d.appspot.com/o/pepe.jfif?alt=media&token=753c6188-cc77-4c18-953a-b8db8b89c8a1',
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
                  builder: (context) => DetailPageWidget(),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              padding: EdgeInsets.only(left: 50, right: 50),
              // Replace the text content as needed
              child: Text(
                '''Replace this text with your content''',
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          // 태그 컨테이너
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 50),
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // Add the action for the first tag
                  },
                  child: Text(
                    // Replace '#홀란드' with your first tag
                    '#Tag1',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Container(
                child: TextButton(
                  onPressed: () {
                    // Add the action for the second tag
                  },
                  child: Text(
                    // Replace '#잘생김' with your second tag
                    '#Tag2',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          // 작성 날짜 및 마음, 댓글, 리컨텐츠 컨테이너
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    // Replace '23/09/15 Fri xx:xx' with your date and time
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
