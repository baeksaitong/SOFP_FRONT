// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/navigates.dart';
import 'result/search_result_image.dart';

class ImageSearch extends StatelessWidget {
  final List<CameraDescription> cameras;

  const ImageSearch({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '사진 검색',
          textAlign: TextAlign.center,
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
  XFile? _firstImageFile;
  XFile? _secondImageFile;
  final ImagePicker _picker = ImagePicker();
  File? _latestImage;
  bool _isLoadingImage = false;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    // _loadLatestImage(); // 이 줄을 제거했습니다.
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isNotEmpty) {
      _controller = CameraController(widget.cameras.first, ResolutionPreset.high);
      await _controller!.initialize();
      setState(() {});
    }
  }

  Future<void> _loadLatestImage() async {
    setState(() {
      _isLoadingImage = true;
    });

    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _latestImage = pickedFile != null ? File(pickedFile.path) : null;
      _isLoadingImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: _cameraPreviewWidget(),
        ),
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
        height: 160,
        color: AppColors.bk.withOpacity(0.3),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '알약을 선명하게 찍어주세요',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'pretendard',
                    ),
                  ),
                  Gaps.h8,
                  _shootButton(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: _galleryButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _galleryButton() {
    return GestureDetector(
      onTap: _loadLatestImage, // **갤러리 버튼을 눌렀을 때만 이미지를 로드합니다.**
      child: CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.wh,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: _latestImage != null
                  ? FileImage(_latestImage!) as ImageProvider
                  : const AssetImage('assets/imagesearch/defaultgallery.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  Widget _shootButton() {
    return GestureDetector(
      onTap: _takePicture,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.wh,
        child: CircleAvatar(
          backgroundColor: AppColors.gr600,
          radius: 27,
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Error: 카메라를 선택해주세요.');
      return;
    }
    if (_isTakingPicture) {
      return;
    }

    try {
      setState(() {
        _isTakingPicture = true;
      });
      final XFile? picture = await _controller!.takePicture();
      if (picture == null) {
        print('Error: 사진을 찍지 못했습니다.');
        return;
      }
      if (_firstImageFile == null) {
        setState(() {
          _firstImageFile = picture;
        });
        _showFirstConfirmationDialog();
      } else if (_secondImageFile == null) {
        setState(() {
          _secondImageFile = picture;
        });
        _showSecondConfirmationDialog();
      }
    } catch (e) {
      print('사진 촬영에 실패했습니다: $e');
    } finally {
      setState(() {
        _isTakingPicture = false;
      });
    }
  }

  void _showFirstConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontFamily: 'pretendard',
              color: AppColors.bk,
            ),
          ),
          content: Text('알약의 뒷면 촬영으로 넘어갈까요? \n다시 촬영하려면 아니오를 누르시오'),
          actions: <Widget>[
            TextButton(
              child: Text('아니요',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'pretendard',
                  color: AppColors.bk,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _firstImageFile = null;
                });
              },
            ),
            TextButton(
              child: Text('네',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'pretendard',
                  color: AppColors.vibrantTeal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSecondConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '알림',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontFamily: 'pretendard',
              color: AppColors.bk,
            ),
          ),
          content: Text(
            '검색하시겠습니까? \n처음부터 다시하려면 아니요를 누르시오',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'pretendard',
              color: AppColors.bk,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '아니요',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'pretendard',
                  color: AppColors.bk,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _firstImageFile = null;
                  _secondImageFile = null;
                });
              },
            ),
            TextButton(
              child: Text(
                '검색',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'pretendard',
                  color: AppColors.vibrantTeal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToSearchResultPage(); // **검색 버튼 클릭 시 호출**
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToSearchResultPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultPage(
          firstImageFile: _firstImageFile, // **첫 번째 이미지 파일 전달**
          secondImageFile: _secondImageFile, // **두 번째 이미지 파일 전달**
        ),
      ),
    );
  }

  void _performSearch() {
    print('Performing search with the captured images.');
    // gpt에서 만들어준 텍스트 일단 그냥 두겠음
  }

  void _switchCamera() async {
    if (_controller == null) return;

    final currentDirection = _controller!.description.lensDirection;

    CameraDescription newCamera = widget.cameras.firstWhere(
          (camera) => camera.lensDirection != currentDirection,
      orElse: () => _controller!.description,
    );

    if (newCamera != _controller!.description) {
      CameraController newController = CameraController(
        newCamera,
        ResolutionPreset.high,
      );

      await _controller?.dispose();
      _controller = newController;
      await _controller?.initialize();
      setState(() {});
    }
  }
}
