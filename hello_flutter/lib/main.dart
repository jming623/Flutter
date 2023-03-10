import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          //화면에 그려주는 부분
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Hello Flutter',
              style: TextStyle(fontSize: 28),
            ),
          ), //상단바
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Image.network(
                      "https://i.ibb.co/CwzHq4z/trans-logo-512.png",
                      width: 81,
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '이메일',
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                    ),
                  ),
                  Container(
                    width: double.infinity, //화면을 디바이스 구분없이 꽉 채우고 싶을 때
                    margin: const EdgeInsets.only(top: 24),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('로그인'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
