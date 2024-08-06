// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


// Project imports:
import 'package:sopf_front/screens/search/search_image.dart';
import 'package:sopf_front/screens/map/map_pharmacy.dart';
import 'package:sopf_front/screens/search/result/serach_result_pill_detail.dart';
import 'package:sopf_front/providers/provider.dart';
import 'package:sopf_front/screens/search/result/search_result.dart';
import 'package:sopf_front/screens/search/search_text.dart';
import 'package:sopf_front/screens/sign/sign_in.dart';
import 'constans/colors.dart';
import 'screens/calendar/calenderPage.dart';
import 'home.dart';
import 'providers/provider_loading.dart';
import 'screens/multi_profile/multi_profile_add.dart';

/* hanjo
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  CameraDescription? firstCamera;

  if (cameras.isNotEmpty) {
    firstCamera = cameras.first;
  }
  runApp(MyApp(camera: firstCamera));
}
*/


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final cameras = await availableCameras();
  CameraDescription? firstCamera;

  if (cameras.isNotEmpty) {
    firstCamera = cameras.first;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => DrugInfoDetailProvider()),
        ChangeNotifierProvider(
            create: (_) => LoadingProvider()), // Add LoadingProvider
      ],
      child: MyApp(camera: firstCamera),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final CameraDescription? camera;

  const MyApp({super.key, this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   textSelectionTheme: TextSelectionThemeData(
      //     cursorColor: Colors.grey, // Set the global cursor color here
      //   ),
      //   inputDecorationTheme: InputDecorationTheme(
      //     border: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(4.0),
      //       borderSide: BorderSide(
      //         color: AppColors.gr600, // The color of the border
      //       ),
      //     ),
      //     enabledBorder: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(4.0),
      //       borderSide: BorderSide(
      //         color: AppColors.gr600, // The color of the border when enabled
      //       ),
      //     ),
      //     focusedBorder: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(4.0),
      //       borderSide: BorderSide(
      //         color: AppColors.gr600, // The color of the border when focused
      //       ),
      //     ),
      //   ),
      // ),
      navigatorKey: navigatorKey,
      home: SplashScreen(), // Show the splash screen first
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        Duration(seconds: 3), () {}); // Show splash screen for 3 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MultiProfileAdd()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/splash.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
      // home: PharmacyMap(),
      // home: ImageSearch(cameras: [camera],), // `CameraScreen`에 카메라 객체를 전달합니다.
    );
  }
}
