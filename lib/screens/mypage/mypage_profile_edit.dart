import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/managers/managers_global_response.dart';
import 'package:sopf_front/managers/managers_jwt.dart';
import 'package:sopf_front/models/models_profile.dart';
import 'package:sopf_front/services/services_profile.dart';

class MyPageProfileEdit extends StatefulWidget {
  final String profileId;

  MyPageProfileEdit({required this.profileId});

  @override
  _MyPageProfileEditState createState() => _MyPageProfileEditState();
}

class _MyPageProfileEditState extends State<MyPageProfileEdit> {
  XFile? _image;
  String? _networkImageUrl;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final JWTManager jwtManager = JWTManager();
  final GlobalResponseManager responseManager = GlobalResponseManager();
  final ProfileService profileService = ProfileService();

  String gender = "MALE";
  String color = "";  // 초기값 없이 빈 문자열 설정
  ColorItem? selectedColorItem;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    birthdateController.addListener(_updateBirthdayFormat);
    _loadProfileDetail();
  }

  Future<void> _loadProfileDetail() async {
    ProfileDetail? profileDetail = await profileService.profileDetail(context);
    if (profileDetail != null) {
      setState(() {
        nameController.text = profileDetail.name;
        birthdateController.text = profileDetail.birthday;
        gender = profileDetail.gender;
        color = profileDetail.color;  // 서버에서 전달된 색상 이름 사용
        _networkImageUrl = profileDetail.imgURL ?? 'assets/mypageEdit/user-icon.png';
      });
    } else {
      print('프로필 로드 실패');
    }
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

  Future<void> saveProfile() async {
    final String name = nameController.text;
    final String birthdate = birthdateController.text.replaceAll('.', '-');
    final String accessToken = await jwtManager.getValidAccessToken();
    final ProfileService profileService = ProfileService();

    var url = Uri.parse('http://3.39.8.147:8080/app/profile/${widget.profileId}');
    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $accessToken';

    request.fields['name'] = name;
    request.fields['birthday'] = birthdate;
    request.fields['gender'] = gender;
    request.fields['color'] = color;

    if (_image != null && _image!.path.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('profileImg', _image!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      responseManager.addResponse(responseString);

      print('$name, $birthdate, $gender, $color');
      print('프로필이 성공적으로 저장되었습니다');

      profileService.profileAll();

      // 저장 성공 시 MyPage로 이동
      Navigator.pop(context); // 이전 화면으로 돌아감

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 정보를 반영하려면 애플리케이션을 재시동해주세요.')),
      );
    } else {
      print('Failed to save profile');
      print('Status code: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
    }
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          ? NetworkImage(_networkImageUrl!)
                          : AssetImage('assets/mypageEdit/user-icon.png') as ImageProvider)
                          : AssetImage('assets/mypageEdit/user-icon.png')),
                    ),
                  ),
                  SizedBox(width: 16), // 아이콘과 버튼 간격 추가
                  RgbButton(
                    onColorSelected: (ColorItem selected) {
                      setState(() {
                        selectedColorItem = selected;
                        color = selected.text; // 선택한 색상 이름으로 저장
                      });
                    },
                  ),
                ],
              ),
            ),
            Gaps.h20,
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

// CustomTextField 클래스 추가
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

// RgbButton 클래스와 ColorItem 모델 추가
class RgbButton extends StatefulWidget {
  final Function(ColorItem) onColorSelected;

  const RgbButton({Key? key, required this.onColorSelected}) : super(key: key);

  @override
  State<RgbButton> createState() => _RgbButtonState();
}

class _RgbButtonState extends State<RgbButton> {
  ColorItem? selectedColorItem;
  Color? finalColor;
  String? finalText;

  void resetSelection() {
    setState(() {
      selectedColorItem = null;
      finalColor = null;
      finalText = null;
      for (var item in colorItems) {
        item.isSelected = false;
      }
    });
  }

  Widget customRgbCircle() {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        color: finalColor,
        borderRadius: BorderRadius.all(Radius.circular(45)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: AppColors.wh,
        minimumSize: Size(75.5, 75.5),
      ),
      onPressed: () async {
        final ColorItem? selected = await showModalBottomSheet<ColorItem>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColors.gr150,
              ),
              padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '색상 선택',
                    style: AppTextStyles.title3S18,
                  ),
                  Gaps.h16,
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 8,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 10,
                      childAspectRatio: (36 / 62),
                      children: List.generate(colorItems.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedColorItem != null) {
                                selectedColorItem!.isSelected = false;
                              }
                              selectedColorItem = colorItems[index];
                              selectedColorItem!.isSelected = true;
                            });
                            Navigator.of(context).pop(selectedColorItem);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 22,
                                width: 22,
                                decoration: BoxDecoration(
                                  color: colorItems[index].color,
                                  borderRadius: BorderRadius.all(Radius.circular(45)),
                                  border: colorItems[index].isSelected
                                      ? Border.all(width: 2.0, color: Colors.redAccent)
                                      : null,
                                ),
                              ),
                              Gaps.h10,
                              Text(
                                colorItems[index].text,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body5M14.copyWith(color: AppColors.gr800),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  Gaps.h32,
                ],
              ),
            );
          },
        );
        if (selected != null) {
          setState(() {
            finalColor = selected.color;
            finalText = selected.text;
            widget.onColorSelected(selected);
            for (var item in colorItems) {
              item.isSelected = false;
            }
          });
        }
      },
      child: Column(
        children: [
          finalColor != null
              ? customRgbCircle()
              : Image.asset(
            'assets/solar_pallete-2-bold-duotone.png',
            width: 32,
            height: 32,
          ),
          Gaps.h4,
          Text(
            finalText ?? '색상',
            style: AppTextStyles.body5M14.copyWith(color: AppColors.bk),
          ),
        ],
      ),
    );
  }
}

class ColorItem {
  final Color color;
  final String text;
  bool isSelected;

  ColorItem({required this.color, required this.text, this.isSelected = false});
}

final List<ColorItem> colorItems = [
  ColorItem(color: Colors.white, text: '하양'),
  ColorItem(color: Colors.yellow, text: '노랑'),
  ColorItem(color: Colors.orange, text: '주황'),
  ColorItem(color: Colors.pink, text: '분홍'),
  ColorItem(color: Colors.red, text: '빨강'),
  ColorItem(color: Colors.brown, text: '갈색'),
  ColorItem(color: Colors.lightGreen, text: '연두'),
  ColorItem(color: Colors.green, text: '초록'),
  ColorItem(color: Colors.blueGrey, text: '청록'),
  ColorItem(color: Colors.blue, text: '파랑'),
  ColorItem(color: Colors.indigo, text: '남색'),
  ColorItem(color: Colors.deepPurple, text: '자주'),
  ColorItem(color: Colors.purple, text: '보라'),
  ColorItem(color: Colors.grey, text: '회색'),
  ColorItem(color: Colors.black, text: '검정'),
  ColorItem(color: Color(0x00d9d9d9), text: '투명'),
];
