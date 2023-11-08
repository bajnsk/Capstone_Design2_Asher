
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import '../Appbar/v_appbar_widget.dart';




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 메뉴
class MenuWidget extends StatefulWidget {



  @override
  State<MenuWidget> createState() => MenuWidgetState();
}
class MenuWidgetState extends State<MenuWidget> {

  int selectedIndex = 0;
  List<Widget> menuWidgetList = [
    MainPageWidget(key: UniqueKey()),
    TagPageWidget(key: UniqueKey()),
    MyPageWidget(key: UniqueKey()),
  ];

  void selectMenu(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AsherAppbar(),
      body: menuWidgetList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300], // 배경 색상을 회색(Shades of Grey 300)으로 설정
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: selectMenu,
        selectedItemColor: Colors.black, // 선택된 항목의 폰트 색상을 검정으로 설정
        unselectedItemColor: Colors.grey, // 선택되지 않은 항목의 폰트 색상을 회색으로 설정
        selectedLabelStyle: GoogleFonts.bebasNeue(fontSize: 16, fontWeight: FontWeight.bold), // 선택된 항목의 폰트 스타일 설정
        unselectedLabelStyle: GoogleFonts.bebasNeue(fontSize: 16), // 선택되지 않은 항목의 폰트 스타일 설정
      ),
    );
  }
}

// 이미지 검색
class MainPageWidget extends StatefulWidget {
  MainPageWidget({Key? key}) : super(key: key);

  @override
  State<MainPageWidget> createState() {
    return ImageSearchPageWidgetState();
  }
}
class ImageSearchPageWidgetState extends State<MainPageWidget> {

  List<String> imageUrls = [];
  List<String> imageTittle = [];
  List<String> imageDates = [];
  List<String> imageSources = [];
  String apiKey = '894702417e89ef951cd0d79fabd04620'; // 본인의 카카오 API 키로 대체
  TextEditingController searchController = TextEditingController();


  // 관심 버튼 처리

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요',
                    labelText: '이미지 검색',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {  }, child: null,
              ),
            ],
          ),
        ),
      ],
    );
  }

}



// 내용 검색
class TagPageWidget extends StatefulWidget {
  TagPageWidget({Key? key}) : super(key: key);

  @override
  State<TagPageWidget> createState() => _ContentSearchPageWidgetState();
}
class _ContentSearchPageWidgetState extends State<TagPageWidget> {
  List<String> contentTitles = [];
  List<String> contentDescriptions = [];
  List<String> contentTimes = [];
  List<String> contentSources = [];
  String apiKey = '894702417e89ef951cd0d79fabd04620'; // 본인의 카카오 API 키로 대체
  TextEditingController searchController = TextEditingController();

  void searchContent() async {
    String query = searchController.text;
    int page = 1;

    String url = 'https://dapi.kakao.com/v2/search/web?query=$query&page=$page';

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'KakaoAK $apiKey';

    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        List<dynamic> documents = data['documents'];

        // 각 목록 초기화
        contentTitles.clear();
        contentDescriptions.clear();
        contentTimes.clear();
        contentSources.clear();


        for (var document in documents) {
          contentTitles.add(document['title']);
          contentDescriptions.add(document['contents']);
          contentTimes.add(document['datetime']);
          contentSources.add(document['url']);
          // ContentFavoriteList에 기본값 추가

        }

        setState(() {});
      } else {
        print('API 요청에 실패했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('API 요청 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요',
                    labelText: '컨텐츠 검색',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: searchContent,
                child: Text('검색'),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildContentItem(String title, String description, String time, String source, bool isFavorite, int index) {
    return GestureDetector(
      onTap: () {
        // 컨텐츠 클릭 시 상세 정보 페이지 이동
      },
      child: Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 3.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(description),
                  Text(time),
                  Text(source),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}

//내용 상세 검색

// 관심목록
class MyPageWidget extends StatefulWidget {
  MyPageWidget({Key? key}) : super(key: key);

  @override
  State<MyPageWidget> createState() => _WatchListPageWidgetState();
}
class _WatchListPageWidgetState extends State<MyPageWidget> {




  @override
  void initState() {
    super.initState();
    // Initially, show all items

  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(

      ),
    );
  }
}

//관심목록 필터


