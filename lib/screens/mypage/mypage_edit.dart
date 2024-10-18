// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/services/services_member.dart';
import '../../constans/gaps.dart';
import '../../managers/managers_jwt.dart';
import '../../models/models_member_info.dart';

class MyPageEdit extends StatefulWidget {
  final String profileId;

  MyPageEdit({required this.profileId});

  @override
  _MyPageEditState createState() => _MyPageEditState();
}

class _MyPageEditState extends State<MyPageEdit> {
  XFile? _image;
  String? _networkImageUrl; // 프로필 이미지 URL을 저장할 변수
  final ImagePicker _picker = ImagePicker();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool _isSubscribed = false;
  late MemberInfo memberInfo;
  final MemberService memberService = MemberService();

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: '');
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    fetchMemberInfo();
  }

  Future<void> fetchMemberInfo() async {
    MemberInfo? fetchedMemberInfo = await memberService.fetchMemberInfo();
    if (fetchedMemberInfo != null) {
      setState(() {
        memberInfo = fetchedMemberInfo;
        emailController.text = memberInfo.email;
        _isSubscribed = memberInfo.advertisement;
      });
    }
  }

  Future<void> getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    } else {
      logger.e('No image selected.');
    }
  }

  Future<void> saveData() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('비밀번호가 일치하지 않습니다.'),
      ));
      return;
    }

    bool isSuccess = await memberService.saveMemberData(
      passwordController.text,
      _isSubscribed,
    );

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('정보가 성공적으로 저장되었습니다.'),
      ));
      Navigator.pop(context, {
        'email': emailController.text,
        'image': _image?.path,
        'isSubscribed': _isSubscribed,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('저장 중 오류가 발생했습니다. 다시 시도해주세요.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        title: Text(
          '회원정보 변경',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'pretendard',
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.wh,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: getImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.wh,
                      backgroundImage: _image != null
                          ? FileImage(File(_image!.path))
                          : (_networkImageUrl != null && _networkImageUrl!.isNotEmpty
                          ? (Uri.tryParse(_networkImageUrl!)?.isAbsolute == true
                          ? NetworkImage(_networkImageUrl!) // 네트워크 이미지 URL
                          : AssetImage(_networkImageUrl!) as ImageProvider) // 로컬 애셋 이미지
                          : AssetImage('assets/mypageEdit/user-icon.png') as ImageProvider), // 기본 이미지 처리
                    ),
                  ),
                  Gaps.h20,
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomTextField(
                  label: "이메일",
                  controller: emailController,
                  isReadOnly: true,
                  hintText: '',
                ),
                Gaps.h10,
                CustomTextField(
                  label: "비밀번호",
                  hintText: "영문, 숫자 포함 10자 이상",
                  isPassword: true,
                  controller: passwordController,
                ),
                Gaps.h10,
                CustomTextField(
                  label: "비밀번호 확인",
                  hintText: "비밀번호를 다시 입력해주세요",
                  isPassword: true,
                  controller: confirmPasswordController,
                ),
                Gaps.h10,
                ElevatedButton(
                  onPressed: saveData,
                  child: Text(
                    '저장',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'pretendard',
                      color: AppColors.wh,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: AppColors.vibrantTeal,
                    minimumSize: Size.fromHeight(48),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final bool isReadOnly;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'pretendard',
            color: AppColors.gr500,
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.wh), // 테두리 색상을 흰색으로 설정
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.wh), // 비활성 상태의 테두리 색상을 흰색으로 설정
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.wh), // 포커스된 상태의 테두리 색상을 흰색으로 설정
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontFamily: 'pretendard',
              fontWeight: FontWeight.w600,
              color: AppColors.gr400,
            ),
            filled: true,
            fillColor: AppColors.gr150,
          ),
        ),
      ],
    );
  }
}