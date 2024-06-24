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

class multiProfileEdit extends StatefulWidget {
  @override
  _multiProfileEditState createState() => _multiProfileEditState();
}

class _multiProfileEditState extends State<multiProfileEdit> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  String gender = "남성"; // 초기값 설정

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
    final String birthdate = birthdateController.text;

    var requestData = {
      "name": name,
      "birthdate": birthdate, //birthdate=> birthday 나중에 수정
      "gender": gender, 
    };

    if (_image != null) {
      var request = http.MultipartRequest('POST', Uri.parse('15.164.18.65'));
      request.fields['name'] = name;
      request.fields['birthdate'] = birthdate;
      request.fields['gender'] = gender;
      request.files.add(await http.MultipartFile.fromPath('profile_image', _image!.path)); // profile_image => profileImg

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Profile saved successfully');
      } else {
        print('Failed to save profile');
      }
    } else {
      // 파일이 없으면 일반 POST 요청
      var response = await http.post(
        Uri.parse('15.164.18.65'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 200) {
        print('Profile saved successfully');
      } else {
        print('Failed to save profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        title: Text('멀티프로필 추가/수정',
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
                      Text("성별",
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
                        items: <String>['남성', '여성']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
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
                ),
                Gaps.h20,
                ElevatedButton(
                  onPressed: saveProfile,
                  child: Text('저장',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.wh,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
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

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
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
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gr400
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
