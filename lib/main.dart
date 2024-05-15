import 'package:flutter/material.dart';
import 'package:sopf_front/exColorsText.dart';
import 'package:sopf_front/searchResult.dart';
import 'package:sopf_front/textSearch.dart';
import 'home.dart';
import 'mypage.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const HomePage(),
    );
  }
}