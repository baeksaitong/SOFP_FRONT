import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/appTextStyles.dart';
import 'package:sopf_front/gaps.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sopf_front/jwtManager.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final JWTmanager jwtManager = JWTmanager();

  String gender = "MALE"; // 초기값 설정을 API에 맞게 변경
  String color = "#FFFFFF"; // color 필드 추가

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
    final String birthdate = birthdateController.text.replaceAll('.', '-'); // yyyy.MM.dd 형식을 yyyy-MM-dd 형식으로 변경
    final String? accessToken = await jwtManager.getValidAccessToken();

    var requestData = {
      "name": name,
      "birthday": birthdate,
      "gender": gender,
      "color": color,
    };

    if (_image != null) {
      var request = http.MultipartRequest('POST', Uri.parse('http://15.164.18.65:8080/app/profile'));
      request.headers['Authorization'] = 'Bearer $accessToken'; // 토큰 추가
      request.fields['name'] = name;
      request.fields['birthday'] = birthdate;
      request.fields['gender'] = gender;
      request.fields['color'] = color;
      request.files.add(await http.MultipartFile.fromPath('profileImg', _image!.path)); // 'profile_image'를 'profileImg'로 변경

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Profile saved successfully');
      } else {
        print('Failed to save profile');
        print('Status code: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
      }
    } else {
      // 파일이 없으면 일반 POST 요청
      var response = await http.post(
        Uri.parse('http://15.164.18.65:8080/app/profile'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // 토큰 추가
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 200) {
        print('Profile saved successfully');
      } else {
        print('Failed to save profile');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
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
    if (text.length == 4 || text.length == 7) {
      birthdateController.value = TextEditingValue(
        text: '$text-',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          fontWeight: FontWeight.w500, // Medium
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
                  hintText: "예) 1999-03-05", // 힌트도 변경
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
            fontWeight: FontWeight.w500, // Medium
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
