import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(home: ImageSearch(cameras: cameras)));
}

class ImageSearch extends StatelessWidget {
  final List<CameraDescription> cameras;

  const ImageSearch({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImageFromGallery(context),
        child: Image.asset('assets/gallery_green.png', width: 47, height: 47),
        backgroundColor: Colors.white,
      ),
      body: CameraScreen(cameras: cameras),
    );
  }

  void _pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('선택된 이미지 경로: ${pickedFile.path}');
    } else {
      print('선택된 이미지가 없습니다.');
    }
  }
}

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
    if (await Permission.camera.isGranted) {
      if (widget.cameras.isNotEmpty) {
        _controller = CameraController(
          widget.cameras.first,
          ResolutionPreset.medium,
        );
        await _controller?.initialize();
        setState(() {});
      }
    } else {
      print('카메라 권한이 거부되었습니다.');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePictureAndUpload() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print("Error: 카메라를 선택해주세요");
      return;
    }
    if (_controller!.value.isTakingPicture) {
      return;
    }

    try {
      final XFile? picture = await _controller!.takePicture();
      setState(() {
        _imageFile = picture;
      });
    } catch (e) {
      print('사진 촬영에 실패했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: _controller != null && _controller!.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              )
                  : Center(child: Text('카메라를 시작할 수 없습니다.')),
            ),
          ),
          Text(
            '알약의 뒷면을\n선명하게 촬영해주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 120),
        ],
      ),
      floatingActionButton: Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.greenAccent,
            width: 4,
          ),
        ),
        child: FloatingActionButton(
          onPressed: _takePictureAndUpload,
          child: Image.asset('assets/camera.png', width: 50, height: 50),
          backgroundColor: Colors.transparent,
          elevation: 0,
          splashColor: Colors.transparent,
          highlightElevation: 0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}