import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:photo_view/photo_view.dart';

void main() {
  runApp(MyApp());
}

class ImageFavoriteData {
  final String imageUrl;
  final String title;
  final String date;
  final String source;

  ImageFavoriteData({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.source,
  });
}
class ContentFavoriteData {
  final String title;
  final String description;
  final String time;
  final String source;

  ContentFavoriteData({
    required this.title,
    required this.description,
    required this.time,
    required this.source,
  });
}

List<bool> ImageFavoriteList = [];
List<bool> ContentFavoriteList = [];

List<ImageFavoriteData> favoriteImages = [];
List<ContentFavoriteData> favoriteContents = [];


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
  State<MenuWidget> createState() => _MenuWidgetState();
}
class _MenuWidgetState extends State<MenuWidget> {
  int _selectedIndex = 0;
  List<Widget> menuWidgetList = [
    ImageSearchPageWidget(key: UniqueKey()),
    ContentSearchPageWidget(key: UniqueKey()),
    WatchListPageWidget(key: UniqueKey()),
  ];

  List<String> appBarTitles = ['이미지 검색', '컨텐츠 검색', '관심 목록'];

  void selectMenu(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitles[_selectedIndex]),
      ),
      body: menuWidgetList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: '이미지 검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: '컨텐츠 검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '관심 목록',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: selectMenu,
      ),
    );
  }
}

// 이미지 검색
class ImageSearchPageWidget extends StatefulWidget {
  ImageSearchPageWidget({Key? key}) : super(key: key);

  @override
  State<ImageSearchPageWidget> createState() {
    return ImageSearchPageWidgetState();
  }
}
class ImageSearchPageWidgetState extends State<ImageSearchPageWidget> {

  List<String> imageUrls = [];
  List<String> imageTittle = [];
  List<String> imageDates = [];
  List<String> imageSources = [];
  String apiKey = '894702417e89ef951cd0d79fabd04620'; // 본인의 카카오 API 키로 대체
  TextEditingController searchController = TextEditingController();

  void searchImages() async {
    String query = searchController.text;
    int page = 1;

    String url = 'https://dapi.kakao.com/v2/search/image?query=$query&page=$page';

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'KakaoAK $apiKey';

    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;

        if (data.containsKey('documents')) {
          List<dynamic> documents = data['documents'];

          imageUrls.clear();
          imageTittle.clear();
          imageDates.clear();
          imageSources.clear();
          ImageFavoriteList.clear();

          for (var document in documents) {
            imageUrls.add(document['image_url']); // 미리보기 이미지 URL로 변경
            imageTittle.add(document['title'] ?? ''); // title이 null이면 빈 문자열로 설정
            imageDates.add(document['datetime'] ?? ''); // datetime이 null이면 빈 문자열로 설정
            imageSources.add(document['doc_url'] ?? ''); // doc_url이 null이면 빈 문자열로 설정
            ImageFavoriteList.add(false);
          }

          setState(() {});
        } else {
          print('API 응답 데이터에 "documents" 키가 없습니다.');
        }
      } else {
        print('API 요청에 실패했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('API 요청 중 오류 발생: $e');
    }
  }

  void _toggleImageFavorite(int index) {
    setState(() {
      if (ImageFavoriteList[index]) {
        // 이미 관심 이미지에 있는 경우, 제거합니다.
        ImageFavoriteList[index] = false;
        favoriteImages.removeWhere((item) => item.imageUrl == imageUrls[index]);
      } else {
        // 관심 이미지 목록에 추가합니다.
        ImageFavoriteList[index] = true;
        favoriteImages.add(ImageFavoriteData(
          imageUrl: imageUrls[index],
          title: imageTittle[index],
          date: imageDates[index],
          source: imageSources[index],
        ));
      }
    });
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
                    labelText: '이미지 검색',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: searchImages,
                child: Text('검색'),
              ),
            ],
          ),
        ),
        for (int i = 0; i < imageUrls.length; i++)
          _buildImageItem(
            imageUrls[i],
            imageTittle[i],
            imageDates[i],
            imageSources[i],
            ImageFavoriteList[i],
            i,
          ),
      ],
    );
  }
  Widget _buildImageItem(String imageUrl, String title, String date, String source, bool isFavorite, int index) {
    return GestureDetector(
      onTap: () {
        // 이미지 클릭 시, 이미지 상세 정보 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageDetailPageWidget(
              imageUrl: imageUrl,
              name: title,
              date: date,
              source: source,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 3.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 3.0),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 3.0),
                      ),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 3.0),
                      ),
                    ),
                    child: Text(date),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 3.0),
                      ),
                    ),
                    child: Text(source),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                _toggleImageFavorite(index); // 관심 이미지를 추가 또는 제거
              },
            ),
          ],
        ),
      ),
    );
  }
}

//이미지 검색 후 상세 설명 보기, 이미지 확대하기
class ImageDetailPageWidget extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String date;
  final String source;

  ImageDetailPageWidget({
    required this.imageUrl,
    required this.name,
    required this.date,
    required this.source,
  });

  @override
  State<ImageDetailPageWidget> createState() {
    return ImageDetailPageWidgetState();
  }
}
class ImageDetailPageWidgetState extends State<ImageDetailPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이미지 상세'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Scaffold(
                  appBar: AppBar(),
                  body: Container(
                    child: PhotoView(
                      imageProvider: NetworkImage(widget.imageUrl),
                    ),
                  ),
                );
              }));
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(widget.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '날짜: ${widget.date}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '출처: ${widget.source}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// 내용 검색
class ContentSearchPageWidget extends StatefulWidget {
  ContentSearchPageWidget({Key? key}) : super(key: key);

  @override
  State<ContentSearchPageWidget> createState() => _ContentSearchPageWidgetState();
}
class _ContentSearchPageWidgetState extends State<ContentSearchPageWidget> {
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
        ContentFavoriteList.clear();

        for (var document in documents) {
          contentTitles.add(document['title']);
          contentDescriptions.add(document['contents']);
          contentTimes.add(document['datetime']);
          contentSources.add(document['url']);
          // ContentFavoriteList에 기본값 추가
          ContentFavoriteList.add(false);
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
        for (int i = 0; i < contentTitles.length; i++)
          _buildContentItem(
            contentTitles[i],
            contentDescriptions[i],
            contentTimes[i],
            contentSources[i],
            ContentFavoriteList[i],
            i,
          ),
      ],
    );
  }
  Widget _buildContentItem(String title, String description, String time, String source, bool isFavorite, int index) {
    return GestureDetector(
      onTap: () {
        // 컨텐츠 클릭 시, 상세 정보 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContentDetailPageWidget(
              title: title,
              description: description,
              time: time,
              source: source,
            ),
          ),
        );
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
                setState(() {
                  ContentFavoriteList[index] = !isFavorite;
                  if (isFavorite) {
                    favoriteContents.removeWhere((item) => item.title == title);
                  } else {
                    favoriteContents.add(ContentFavoriteData(
                      title: title,
                      description: description,
                      time: time,
                      source: source,
                    ));
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

//내용 상세 검색
class ContentDetailPageWidget extends StatefulWidget {
  final String title;
  final String description;
  final String time;
  final String source;

  ContentDetailPageWidget({
    required this.title,
    required this.description,
    required this.time,
    required this.source,
  });

  @override
  State<ContentDetailPageWidget> createState() {
    return ContentDetailPageWidgetState();
  }
}
class ContentDetailPageWidgetState extends State<ContentDetailPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('컨텐츠 상세'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.description,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '시간: ${widget.time}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '출처: ${widget.source}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// 관심목록
class WatchListPageWidget extends StatefulWidget {
  WatchListPageWidget({Key? key}) : super(key: key);

  @override
  State<WatchListPageWidget> createState() => _WatchListPageWidgetState();
}
class _WatchListPageWidgetState extends State<WatchListPageWidget> {
  List<dynamic> watchlistItems = [...favoriteImages, ...favoriteContents];
  List<dynamic> filteredWatchlistItems = [];

  FilterType filter = FilterType.All; // Default filter type

  @override
  void initState() {
    super.initState();
    // Initially, show all items
    filteredWatchlistItems = watchlistItems;
  }

  Widget _buildWatchListItem(dynamic item) {
    if (item is ContentFavoriteData) {
      return Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 3.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(item.description),
            Text(item.time),
            Text(item.source),
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                _removeFromWatchList(item);
              },
            ),
          ],
        ),
      );
    } else if (item is ImageFavoriteData) {
      return Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 3.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이미지',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              height: 200,
            ),
            Text(item.title),
            Text(item.date),
            Text(item.source),
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                _removeFromWatchList(item);
              },
            ),
          ],
        ),
      );
    }
    return Container();
  }


  void _removeFromWatchList(dynamic item) {
    setState(() {
      if (item is ContentFavoriteData) {
        watchlistItems.remove(item);
      } else if (item is ImageFavoriteData) {
        watchlistItems.remove(item);
      }
      // Refresh the filtered watchlist
      _filterWatchlist(filter);
    });
  }


  void _filterWatchlist(FilterType filterType) {
    setState(() {
      filter = filterType;
      if (filter == FilterType.All) {
        filteredWatchlistItems = watchlistItems;
      } else if (filter == FilterType.Images) {
        filteredWatchlistItems = watchlistItems.where((item) => item is ImageFavoriteData).toList();
      } else if (filter == FilterType.Contents) {
        filteredWatchlistItems = watchlistItems.where((item) => item is ContentFavoriteData).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilterButton(
                filter: FilterType.All,
                currentFilter: filter,
                onPressed: () {
                  _filterWatchlist(FilterType.All);
                },
              ),
              FilterButton(
                filter: FilterType.Images,
                currentFilter: filter,
                onPressed: () {
                  _filterWatchlist(FilterType.Images);
                },
              ),
              FilterButton(
                filter: FilterType.Contents,
                currentFilter: filter,
                onPressed: () {
                  _filterWatchlist(FilterType.Contents);
                },
              ),
            ],
          ),
          for (var item in filteredWatchlistItems)
            _buildWatchListItem(item),
        ],
      ),
    );
  }
}

//관심목록 필터
class FilterButton extends StatelessWidget {
  final FilterType filter;
  final FilterType currentFilter;
  final VoidCallback onPressed;

  FilterButton({
    required this.filter,
    required this.currentFilter,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
          filter == currentFilter ? Colors.blue : Colors.black,
        ),
      ),
      child: Text(
        _filterTypeToString(filter),
      ),
    );
  }

  String _filterTypeToString(FilterType filterType) {
    switch (filterType) {
      case FilterType.All:
        return '전체';
      case FilterType.Images:
        return '이미지';
      case FilterType.Contents:
        return '컨텐츠';
    }
  }
}
enum FilterType {
  All,
  Images,
  Contents,
}

