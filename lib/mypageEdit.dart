import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sopf_front/appColors.dart';

class MyPageEdit extends StatefulWidget {
  @override
  _MyPageEditState createState() => _MyPageEditState();
}

class _MyPageEditState extends State<MyPageEdit> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController emailController = TextEditingController();

  String gender = "남성"; // 예시로 "남성"을 사용했삼

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정보 수정',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'pretendard',

        ),),
        centerTitle: true,
        backgroundColor: AppColors.wh,// 제목을 가운데 정렬
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // 가운데 정렬을 위한 Column
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
                  SizedBox(height: 20),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomTextField(
                  label: "이름",
                  hintText: "예) 김약속",
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("성별",
                        style: TextStyle(
                          fontFamily: 'pretendard',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.gr500,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.gr150,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        child: Text(gender,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'pretendard',
                            color: AppColors.gr600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                CustomTextField(
                    label: "생년월일",
                    hintText: "예) 20240509"
                ),
                CustomTextField(
                  label: "휴대폰 번호",
                  hintText: "예) 01091664217",
                ),
                SizedBox(height: 10),
                CustomTextField(
                  label: "이메일",
                  hintText: "예) yacsoc123@abcd.com",
                  controller: emailController,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  label: "비밀번호",
                  hintText: "영문, 숫자, 특수문자 포함 10자 이상",
                  isPassword: true,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  label: "비밀번호 확인",
                  hintText: "비밀번호를 다시 입력해주세요",
                  isPassword: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // 저장 기능 추가 필요
                  },


                  child: Text('저장하기',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'pretendard',
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
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: 'pretendard',
              color: AppColors.gr500,
        )),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
                fontFamily: 'pretendard',
                fontWeight: FontWeight.w600,
                color: AppColors.gr400
            ),
            filled: true,
            fillColor: AppColors.gr150,
          ),
        ),
      ],
    );
  }
}
