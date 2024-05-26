import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/globalResponseManager.dart';
import 'gaps.dart';
import 'provider.dart';
import 'package:sopf_front/provider.dart';

class MyPageEdit extends StatefulWidget {
  final Profile profile;

  MyPageEdit({required this.profile});

  @override
  _MyPageEditState createState() => _MyPageEditState();
}

class _MyPageEditState extends State<MyPageEdit> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool _isSubscribed = false; // 광고성 이메일 수신 동의 여부

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.profile.id);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

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

  Future<void> saveData() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('비밀번호가 일치하지 않습니다.'),
      ));
      return;
    }

    final url = Uri.parse('http://15.164.18.65/app/member'); // 수정된 엔드포인트
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': emailController.text,
        'password': passwordController.text,
        'isSubscribed': _isSubscribed,
      }),
    );

    if (response.statusCode == 200) {
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
          '정보 수정',
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
                  label: "이메일",
                  hintText: "예) yacsoc123@abcd.com",
                  controller: emailController,
                  isReadOnly: true, // 수정 불가능하게 설정
                ),
                Gaps.h10,
                CustomTextField(
                  label: "비밀번호",
                  hintText: "영문, 숫자, 특수문자 포함 10자 이상",
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
                CheckboxListTile(
                  title: Text("광고성 이메일 수신 동의"),
                  value: _isSubscribed,
                  onChanged: (bool? value) {
                    setState(() {
                      _isSubscribed = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
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
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'pretendard',
                fontWeight: FontWeight.w600,
                color: AppColors.gr400),
            filled: true,
            fillColor: AppColors.gr150,
          ),
        ),
      ],
    );
  }
}
