import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sopf_front/exColorsText.dart';
import 'package:sopf_front/imageSearch.dart';
import 'imageSearch.dart'; // `CameraScreen` 클래스가 정의된 파일을 임포트하세요.

void main() async {
  // 앱을 시작하기 전에 카메라 목록을 불러옵니다.
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first; // 첫 번째 카메라를 사용합니다.

  runApp(MyApp(camera: firstCamera));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera}); // 생성자에서 카메라 객체를 받습니다.

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: CameraScreen(camera: camera), // `CameraScreen`에 카메라 객체를 전달합니다.
    );
  }
}
