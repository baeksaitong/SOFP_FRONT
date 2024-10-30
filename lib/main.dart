// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:sopf_front/constans/text_styles.dart';


// Project imports:
import 'package:sopf_front/providers/provider.dart';
import 'package:sopf_front/screens/sign/sign_in.dart';
import 'package:sopf_front/services/services_notification.dart';
import 'constans/colors.dart';
import 'home.dart';
import 'providers/provider_loading.dart';

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

  final cameras = await availableCameras();
  CameraDescription? firstCamera;

  if (cameras.isNotEmpty) {
    firstCamera = cameras.first;
  }

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.wh,
    )
  );

  WidgetsFlutterBinding.ensureInitialized();
// NotificationService 초기화
  await NotificationService.initialize();

  // 지금부터 5초 후에 알림 테스트
  DateTime now = DateTime.now();
  DateTime scheduledTime = now.add(Duration(seconds: 5));
  NotificationService.scheduleNotification(scheduledTime, "테스트 알림", "이것은 테스트 알림입니다.");
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
      theme: ThemeData(
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.vibrantTeal; // 체크되었을 때 색상
            }
            return Colors.white; // 체크되지 않았을 때 색상
          }),
        ),
        dialogBackgroundColor: AppColors.wh, // 다이얼로그 배경 다 하얀색!
        // 다이얼로그 버튼 테마 설정 (선택 사항)
        bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.wh,
        ),
        scaffoldBackgroundColor: AppColors.wh,
        appBarTheme: AppBarTheme(
        backgroundColor: AppColors.wh,

        ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: AppColors.vibrantTeal, // 포커스 시 테두리 색상
            width: 2.0,
          ),
        ),
      ),
      ),
      navigatorKey: navigatorKey,
      home: SplashScreen(),
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
      MaterialPageRoute(builder: (context) => SignIn()),
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
