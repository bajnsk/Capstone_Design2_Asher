// c_DetailPageController.dart

import 'package:capstone/DataVO/model.dart';
import 'package:flutter/material.dart';
import 'package:capstone/Home/FeedPage/c_FeedPageController.dart';

import '../MyPage/FollowFriend/v_FollowFriendList.dart';

class DetailPageController {
  static late String getFeedID;
  static void onMoreMenuSelected(BuildContext context, String menu) {
    if (menu == 'Like') {
      // Like 메뉴 선택 시 처리
      print('Like 메뉴 선택');
    } else if (menu == 'Recontents') {
      // Recontents 메뉴 선택 시 처리
      print('Recontents 메뉴 선택');
    } else if (menu == 'Feed to Friends') {
      // Feed to Friends 메뉴 선택 시 처리
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => FollowFriendList()));
    } else if (menu == 'Report') {
      // Report 메뉴 선택 시 처리
      print('Report 메뉴 선택');
    }
  }

  // 더보기 메뉴를 표시하는 함수
  static void showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Like'),
                onTap: () {
                  Navigator.of(context).pop();
                  onMoreMenuSelected(context, 'Like');
                },
              ),
              ListTile(
                leading: Icon(Icons.repeat),
                title: Text('Recontents'),
                onTap: () {
                  Navigator.of(context).pop();
                  onMoreMenuSelected(context, 'Recontents');
                },
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text('Feed to Friends?'),
                onTap: () {
                  Navigator.of(context).pop();
                  onMoreMenuSelected(context, 'Feed to Friends');
                },
              ),
              ListTile(
                  leading: Icon(Icons.report),
                  title: Text('Report?'),
                  onTap: () {
                    Navigator.of(context).pop();
                    onMoreMenuSelected(context, 'Report');
                  })
            ],
          ),
        );
      },
    );
  }
}
