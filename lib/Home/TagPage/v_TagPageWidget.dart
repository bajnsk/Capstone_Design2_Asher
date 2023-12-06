import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capstone/DataVO/model.dart';
import 'package:capstone/Home/DetailPage/v_TagDetailPageWidget.dart';
import 'package:get/get.dart';

class TagPageWidget extends StatefulWidget {
  TagPageWidget({Key? key}) : super(key: key);

  @override
  State<TagPageWidget> createState() => TagPageWidgetState();
}

class TagPageWidgetState extends State<TagPageWidget> {
  List<FeedDataVO> allTagFeedList = DataVO.feedData; // All feed data
  List<FeedDataVO> displayedTagFeedList = DataVO.feedData;

  // Controller for managing selected tags
  late TagController tagController;

  @override
  void initState() {
    super.initState();
    tagController = Get.put(TagController());
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TagController>()) {
      Get.put(TagController());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Center(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 8),
                          child: TextFormField(
                            controller: tagController.tagInputController,
                            onChanged: (value) {
                              setState(() {
                                displayedTagFeedList = allTagFeedList
                                    .where((feed) => feed.tag.contains(value))
                                    .toList();
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '구독할 태그를 추가하세요',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          tagController.addTag();
                        },
                        icon: Icon(
                          CupertinoIcons.plus,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 추가: 검색창 아래에 추가된 태그 표시
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => Wrap(
              spacing: 8.0,
              children: [
                for (String tag in tagController.getSelectedTags)
                  Chip(
                    label: Text(tag),
                    onDeleted: () {
                      tagController.removeTag(tag);
                    },
                  ),
              ],
            ),
          ),
        ),

        Expanded(
          child: GridView.builder(
            itemCount: displayedTagFeedList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              FeedDataVO feed = displayedTagFeedList[index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TagDetailPageWidget(
                        feedData: displayedTagFeedList[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            displayedTagFeedList[index].image[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 3),
                        child: Text(
                          displayedTagFeedList[index].context_text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            for (String tag in displayedTagFeedList[index].tag)
                              Text(
                                tag,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TagController extends GetxController {
  static RxList<String> selectedTags = <String>[].obs;
  final tagInputController = TextEditingController();

  void addTag() {
    if (tagInputController.text.isNotEmpty) {
      selectedTags.add(tagInputController.text);
      // 입력 필드 초기화
      tagInputController.clear();
    }
  }

  void removeTag(String tag) {
    selectedTags.remove(tag);
  }

  // 추가: selectedTags를 반환하는 getter 추가
  List<String> get getSelectedTags => selectedTags.toList();
}
