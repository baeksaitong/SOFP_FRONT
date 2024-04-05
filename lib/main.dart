import 'package:flutter/material.dart';
import 'package:sofp_front/signin.dart';
import 'package:sofp_front/testLogin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestLogin(),
    );
  }
}
