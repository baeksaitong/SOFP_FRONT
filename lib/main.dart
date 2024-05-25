import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sopf_front/addAllergyPage.dart';
import 'package:sopf_front/exColorsText.dart';
import 'package:sopf_front/login.dart';
import 'package:sopf_front/multiProfileEdit.dart';
import 'package:sopf_front/searchResult.dart';
import 'package:sopf_front/signUp.dart';
import 'package:sopf_front/textSearch.dart';
import 'calenderFirstPage.dart';
import 'home.dart';
import 'mypage.dart';


import 'package:camera/camera.dart';
import 'package:sopf_front/exColorsText.dart';
import 'package:sopf_front/imageSearch.dart';
import 'imageSearch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  initializeDateFormatting().then((value) =>
    runApp(MyApp(camera: firstCamera))
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: HomePage(),
    );
  }
}
