import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/appTextStyles.dart';

class ImageSearch extends StatelessWidget {
  final List<CameraDescription> cameras;

  const ImageSearch({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('사진 검색', textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'pretendard',
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF4D4D4D),
        ),
        body: CameraScreen(cameras: cameras),
      );
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
  final ImagePicker _picker = ImagePicker();
  File? _latestImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadLatestImage();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isNotEmpty) {
      _controller =
          CameraController(widget.cameras.first, ResolutionPreset.high);
      await _controller!.initialize();
      setState(() {});
    }
  }

  Future<void> _loadLatestImage() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _latestImage = File(pickedFile.path); // 파일로 변환
      });
    } else {
      setState(() {
        _latestImage = File('assets/imagesearch/defaultgallery.png');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _cameraPreviewWidget(),
        _cameraOverlayWidget(),
      ],
    );
  }

  Widget _cameraPreviewWidget() {
    return _controller != null && _controller!.value.isInitialized
        ? CameraPreview(_controller!)
        : const Center(child: Text('카메라를 시작할 수 없습니다.'));
  }

  Widget _cameraOverlayWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 150,
        color: AppColors.bk.withOpacity(0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _galleryButton(),
            _shootButton(),
            _toggleCameraButton(),
          ],
        ),
      ),
    );
  }

  Widget _galleryButton() {
    return InkWell(
      onTap: _loadLatestImage,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.wh,
        child: CircleAvatar(
          backgroundImage: _latestImage != null
              ? FileImage(_latestImage!) as ImageProvider
              : const AssetImage('assets/imagesearch/defaultgallery.png'),
          radius: 20,
        ),
      ),
    );
  }

  Widget _shootButton() {
    return InkWell(
      onTap: _takePicture,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.wh, // 테두리 색
        child: CircleAvatar(
          backgroundColor: AppColors.gr500,
          radius: 27,
        ),
      ),
    );
  }

  Widget _toggleCameraButton() {
    return InkWell(
      onTap: _switchCamera,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.gr500,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/imagesearch/switchcamera.png'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Error: 카메라를 선택해주세요.');
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

  void _switchCamera() async {
    // 현재 카메라의 렌즈 방향
    final currentDirection = _controller!.description.lensDirection;

    // 전환할 카메라를 결정
    CameraDescription newCamera = widget.cameras.firstWhere(
            (camera) => camera.lensDirection != currentDirection,
        orElse: () => _controller!.description // 같은 카메라 유지를 위한 기본값
    );

    // 새로운 카메라로 컨트롤러를 초기화
    if (newCamera != _controller!.description) {
      CameraController newController = CameraController(
          newCamera,
          ResolutionPreset.high
      );

      // 기존 컨트롤러를 정리하고 새 컨트롤러로 업데이트
      await _controller?.dispose();
      _controller = newController;
      await _controller?.initialize();
      setState(() {}); // UI 업데이트
    }
  }
}