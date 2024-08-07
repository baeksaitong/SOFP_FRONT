// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/managers/managers_global_response.dart';
import 'package:sopf_front/managers/managers_jwt.dart';
import 'package:sopf_front/models/models_profile.dart';

class MyPageProfileEdit extends StatefulWidget {
  final String profileId;

  MyPageProfileEdit({required this.profileId});

  @override
  _MyPageProfileEditState createState() => _MyPageProfileEditState();
}

class _MyPageProfileEditState extends State<MyPageProfileEdit> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final JWTManager jwtManager = JWTManager();
  final GlobalResponseManager responseManager = GlobalResponseManager();

  String gender = "MALE";
  String color = "#FFFFFF";

  Future<void> getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> saveProfile() async {
    final String name = nameController.text;
    final String birthdate = birthdateController.text.replaceAll('.', '-');
    final String accessToken = await jwtManager.getValidAccessToken();

    var url = Uri.parse('http://15.164.18.65:8080/app/profile/${widget.profileId}');
    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $accessToken';

    request.fields['name'] = name;
    request.fields['birthday'] = birthdate;
    request.fields['gender'] = gender;
    request.fields['color'] = color;

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('profileImg', _image!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      responseManager.addResponse(responseString);
      print('프로필이 성공적으로 저장되었습니다');
    } else {
      print('Failed to save profile');
      print('Status code: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    birthdateController.addListener(_updateBirthdayFormat);
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
                          ? FileImage(File(_image!.path)) as ImageProvider<Object>
                          : AssetImage('assets/mypageEdit/user-icon.png') as ImageProvider<Object>,
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
                        items: <String>['MALE', 'FEMALE'].map<DropdownMenuItem<String>>((String value) {
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