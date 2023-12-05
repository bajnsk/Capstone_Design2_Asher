import 'package:capstone/DataVO/model.dart';
import 'package:capstone/Home/DetailPage/v_TagDetailPageWidget.dart';
import 'package:get/get.dart';

class TagController extends TagDetailPageWidget {
  List<FeedDataVO> TagFeedList = DataVO.feedData;

  TagController({required super.feedData});
}
