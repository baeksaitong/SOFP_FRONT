import 'package:flutter/material.dart';
import 'package:sofp_front/gaps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('data'),
              Gaps.w20, // 여백을 부여할 수 있습니다.
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
              )
            ],
          )
        ),
      ),
    );
  }
}
