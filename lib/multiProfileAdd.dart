import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sopf_front/apiClient.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/appTextStyles.dart';
import 'package:sopf_front/gaps.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/shapeSearch.dart';

class MultiProfileAdd extends StatefulWidget {
  @override
  _MultiProfileAddState createState() => _MultiProfileAddState();
}

class _MultiProfileAddState extends State<MultiProfileAdd> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  ColorItem? selectedColorItem; // To store the selected color item

  String gender = "남성"; // 초기값 설정

  Future<void> getImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
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
    String birthdate = birthdateController.text;
    birthdate = birthdate.replaceAll('.', '-');
    final APIClient apiClient = APIClient();
    String colorName = selectedColorItem?.text ?? '초록'; // Default color

    if (gender == '남성') {
      await apiClient.profilePost(name, birthdate, 'MALE', colorName, null);
    } else {
      await apiClient.profilePost(name, birthdate, 'FEMALE', colorName, null);
    }
    navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        title: Text(
          '멀티프로필 추가',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: getImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.wh,
                          backgroundImage: _image != null
                              ? FileImage(File(_image!.path))
                          as ImageProvider<Object>
                              : AssetImage('assets/mypageEdit/user-icon.png')
                          as ImageProvider<Object>,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: RgbButton(
                          onColorSelected: (ColorItem selected) {
                            setState(() {
                              selectedColorItem = selected;
                            });
                          },
                        ),
                      ),
                    ],
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.vibrantTeal, width: 2),
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
                  child: Text(
                    '저장',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
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
                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gr400),
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

class RgbButton extends StatefulWidget {
  final Function(ColorItem) onColorSelected; // Callback for color selection

  const RgbButton({super.key, required this.onColorSelected});

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
        item.isSelected = false; // 모든 colorItems의 isSelected를 false로 설정
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
        padding: EdgeInsets.zero, // 패딩 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: AppColors.wh,
        minimumSize: Size(75.5, 75.5), // 버튼의 최소 크기 설정
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
                      childAspectRatio: (36 / 62), // 아이템 폭 대 높이 비율 조정

                      children: List.generate(colorItems.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedColorItem != null) {
                                selectedColorItem!.isSelected = false;
                              }
                              selectedColorItem = colorItems[index];
                              selectedColorItem!.isSelected = true;
                            }); // 색상 선택 로직 구현
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
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                                  border: colorItems[index].isSelected
                                      ? Border.all(
                                    width: 2.0,
                                    color: Colors.redAccent,
                                  )
                                      : null,
                                ),
                              ),
                              Gaps.h10,
                              Text(
                                colorItems[index].text,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body5M14
                                    .copyWith(color: AppColors.gr800),
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
            finalColor = selected.color; // 선택된 색상 적용
            finalText = selected.text; // 선택된 텍스트 적용
            widget.onColorSelected(selected); // Notify parent widget
            for (var item in colorItems) {
              item.isSelected = false; // 모든 shapeItems의 isSelected를 false로 설정
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

Color? getColorFromText(String colorText) {
  final colorItem = colorItems.firstWhere(
        (item) => item.text == colorText,
    orElse: () => ColorItem(color: Colors.transparent, text: 'Unknown'),
  );
  return colorItem.color;
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
