import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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

/// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String quiz = '';

  @override
  void initState() {
    //initState안에서는 async를 사용할 수 없음
    super.initState();
    getQuiz();
  }

  void getQuiz() async {
    //이런식으로 사용할 수 있음
    quiz = await getNumberTrivia();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getNumberTrivia() async {
    Response res = await Dio().get('http://numbersapi.com/random/trivia');
    String trivia = res.data;
    print(trivia);

    return trivia;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: SafeArea(
        //기기 특성상 위 아래 생기는 공간에 body영역이 침범하지 못하도록 여백을 생성해줌.
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // quiz
              Expanded(
                child: Center(
                  child: Text(
                    quiz,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // New Quiz 버튼
              SizedBox(
                height: 42,
                child: ElevatedButton(
                    child: Text(
                      "New Quiz",
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 24,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: getQuiz //익명함수를 굳이 사용하지 않아도 됨.
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
