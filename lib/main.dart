import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sopf_front/addAllergyPage.dart';
import 'package:sopf_front/exColorsText.dart';
import 'package:sopf_front/login.dart';
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

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/login.dart';
import 'package:sopf_front/provider.dart';

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  initializeDateFormatting().then((value) =>
    runApp(MyApp(camera: firstCamera))
  );
}
*/

void main() async{
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MyApp(camera: firstCamera),
    ),
  );}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const LoginPage(),
      // home: Scaffold(
      //   body: Lottie.asset('assets/loading.json'),
      // ),
    );
  }
}
