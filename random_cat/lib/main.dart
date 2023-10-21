import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // main() 함수에서 async를 쓰려면 필요
  WidgetsFlutterBinding.ensureInitialized();

  // shared_preferences 인스턴스 생성
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CatService(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

/// 고양이 서비스
class CatService extends ChangeNotifier {
  SharedPreferences prefs;

  // 고양이 사진 담을 변수
  List<String> catImages = [];
  // 좋아요 사진 목록
  List<String> favoriteCatImages = [];

  //생성자(Constructor)
  CatService(this.prefs) {
    favoriteCatImages = prefs.getStringList('favoriteCatImages') ?? [];
    getRandomCatImages();
  }

  /// 좋아요 사진 토글
  void toggleFavoriteCatImage(String catImage) {
    if (favoriteCatImages.contains(catImage)) {
      //이미지가 있다면
      favoriteCatImages.remove(catImage);
    } else {
      //이미지가 없다면
      favoriteCatImages.add(catImage);
    }
    notifyListeners(); //ChangeNotifier로 선언된 클래스의 상태변화 시 화면 갱신
    prefs.setStringList('favoriteCatImages', favoriteCatImages);
  }

  /// 랜덤 고양이 사진 API 호출
  void getRandomCatImages() async {
    var result = await Dio().get(
      "https://api.thecatapi.com/v1/images/search?limit=10&mime_types=jpg",
    );

    for (int i = 0; i < result.data.length; i++) {
      String url = result.data[i]['url'];
      print(url);
      catImages.add(url);
    }

    notifyListeners();
  }
}

/// 홈 페이지
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("랜덤 고양이"),
            backgroundColor: Colors.amber,
            actions: [
              // 좋아요 페이지로 이동
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritePage()),
                  );
                },
              )
            ],
          ),
          // 고양이 사진 목록
          body: GridView.count(
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: EdgeInsets.all(8),
            crossAxisCount: 2,
            children: List.generate(
              //배열생성
              catService.catImages.length,
              (index) {
                String catImage = catService.catImages[index];
                return GestureDetector(
                  onDoubleTap: () {
                    catService.toggleFavoriteCatImage(catImage);
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          catImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Icon(
                          Icons.favorite,
                          color: catService.favoriteCatImages.contains(catImage)
                              ? Colors.amber
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// 좋아요 페이지
class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("좋아요"),
            backgroundColor: Colors.amber,
          ),
          body: GridView.count(
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: EdgeInsets.all(8),
            crossAxisCount: 2,
            children: List.generate(
              //배열생성
              catService.favoriteCatImages.length,
              (index) {
                String catImage = catService.favoriteCatImages[index];
                return GestureDetector(
                  onDoubleTap: () {
                    catService.toggleFavoriteCatImage(catImage);
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          catImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Icon(
                          Icons.favorite,
                          color: catService.favoriteCatImages.contains(catImage)
                              ? Colors.amber
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
