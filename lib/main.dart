import 'package:flutter/material.dart';
import 'package:sofp_front/Pill_Details.dart';
import 'package:sofp_front/gaps.dart';
import 'package:sofp_front/image_search.dart';
import 'mypage.dart';
import 'image_search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailPage(),
    );
  }
}