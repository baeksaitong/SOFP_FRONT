import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/managers/managers_global_response.dart';
import 'package:sopf_front/managers/managers_jwt.dart';
import 'package:sopf_front/models/models_profile.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/services/services_profile.dart';

import '../../providers/provider.dart'; // Profile 모델

class MyPageProfileEdit extends StatefulWidget {
  final String profileId;

  MyPageProfileEdit({required this.profileId});

  @override
  _MyPageProfileEditState createState() => _MyPageProfileEditState();
}

class _MyPageProfileEditState extends State<MyPageProfileEdit> {
  XFile? _image;
  String? _networkImageUrl; // 프로필 이미지 URL을 저장할 변수
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final JWTManager jwtManager = JWTManager();
  final GlobalResponseManager responseManager = GlobalResponseManager();
  final ProfileService profileService = ProfileService();

  String gender = "MALE";
  String color = "#FFFFFF";
  bool isLoading = true; // 로딩 상태를 위한 변수

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    birthdateController.addListener(_updateBirthdayFormat);
    _loadProfileDetail(); // 프로필 상세 정보 로딩
  }

  Future<void> _loadProfileDetail() async {
    ProfileDetail? profileDetail = await profileService.profileDetail(context);
    if (profileDetail != null) {
      setState(() {
        nameController.text = profileDetail.name;
        birthdateController.text = profileDetail.birthday;
        gender = profileDetail.gender;
        color = profileDetail.color;
        _networkImageUrl = profileDetail.imgURL ?? 'assets/mypageEdit/user-icon.png'; // 기본 이미지 처리
      });
    } else {
      logger.e('프로필 로드 실패');
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

  Future<void> saveProfile() async {
    final String name = nameController.text;
    final String birthdate = birthdateController.text.replaceAll('.', '-');
    final ProfileService profileService = ProfileService();

    profileService.profilePut(name, birthdate, gender, color, _image, context);

    navigateToHome();
  }

  @override
  void dispose() {
    birthdateController.removeListener(_updateBirthdayFormat);
    birthdateController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _updateBirthdayFormat() {
    String text = birthdateController.text;
    if (text.length == 4 && !text.contains('.')) {
      birthdateController.value = TextEditingValue(
        text: '$text.',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    } else if (text.length == 7 && text.split('.').length - 1 == 1) {
      birthdateController.value = TextEditingValue(
        text: '$text.',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        elevation: 0, // 그림자를 없애서 색 변화 방지
        title: Text(
          '프로필 정보 수정',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.gr700,
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
                          ? NetworkImage(_networkImageUrl!) as ImageProvider<Object>
                          : AssetImage('assets/mypageEdit/user-icon.png')),
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
                  label: "이름",
                  hintText: "예) 김약속",
                  controller: nameController,
                ),
                Gaps.h10,
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "성별",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.gr550,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: gender,
                        icon: Icon(Icons.arrow_drop_down),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: AppColors.gr150,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.vibrantTeal, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            gender = newValue!;
                          });
                        },
                        items: <String>['MALE', 'FEMALE']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value == 'MALE' ? '남성' : '여성',
                              style: AppTextStyles.body5M14,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                CustomTextField(
                  label: "생년월일",
                  hintText: "예) 1999.03.05",
                  controller: birthdateController,
                  keyboardType: TextInputType.number,
                ),
                Gaps.h20,
                ElevatedButton(
                  onPressed: saveProfile,
                  child: Text(
                    '저장',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.wh,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.gr550,
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gr400,
            ),
            filled: true,
            fillColor: AppColors.gr150,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.vibrantTeal, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
