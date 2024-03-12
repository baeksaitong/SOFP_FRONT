import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(home: HomePage(cameras: cameras)));
}

class HomePage extends StatelessWidget {
  final List<CameraDescription> cameras;

  const HomePage({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraScreen(cameras: cameras),
      floatingActionButton: FloatingActionButton(
        // 갤러리에서 이미지 선택
        onPressed: () => _pickImageFromGallery(context),
        child: Icon(Icons.photo_library),
      ),
    );
  }
  void _pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // 이미지 선택 후 처리 로직
  }
}

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Stack(
      children: [
        CameraPreview(_controller), // 카메라 프리뷰
        Positioned(
          bottom: 150,
          left: 50,
          right: 50,
          child: Text(
            '사물을 선명하게 찍어주세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
