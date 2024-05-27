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
import 'appColors.dart';
import 'package:camera/camera.dart';
import 'package:sopf_front/exColorsText.dart';
import 'package:sopf_front/imageSearch.dart';
import 'imageSearch.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/login.dart';
import 'package:sopf_front/provider.dart';

void main() async {
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
        ChangeNotifierProvider(create: (_) => DrugInfoDetailProvider()),
      ],
      child: MyApp(camera: firstCamera),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.grey, // Set the global cursor color here
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: AppColors.gr600, // The color of the border
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: AppColors.gr600, // The color of the border when enabled
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: AppColors.gr600, // The color of the border when focused
            ),
          ),
        ),
      ),
      navigatorKey: navigatorKey,
      home: const LoginPage(),
    );
  }
}
