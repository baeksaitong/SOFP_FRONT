import 'package:flutter/material.dart';
import 'package:sopf_front/apiClient.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/appTextStyles.dart';
import 'package:sopf_front/navigates.dart';
import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Map<String, dynamic>? memberInfo = {'name': '이한조'};
  final List<String> _allergiesanddisease = [
    "꽃가루",
    "먼지",
    "견과류",
    "우유",
    "생선",
    "달걀",
    "조개류",
    "밀",
    "대두",
    "땅콩",
  ];
  final List<String> _medications = [
    "이부프로펜",
    "아세트아미노펜",
    "아목시실린",
    "메트포르민",
    "암로디핀",
    "시모바스타틴",
    "오메프라졸",
    "로사르탄",
    "아스피린",
    "가바펜틴"
  ];

  final List<String> _selectedAllergiesanddisease = [];
  final List<String> _selectedMedications = [];

  void showEditBottomSheet(BuildContext context, String title, String type) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Edit $title',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                ...((type == 'allergy' ? _allergiesanddisease : _medications)
                    .map((item) => CheckboxListTile(
                          title: Text(item),
                          value: type == 'allergy'
                              ? _selectedAllergiesanddisease.contains(item)
                              : _selectedMedications.contains(item),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                type == 'allergy'
                                    ? _selectedAllergiesanddisease.add(item)
                                    : _selectedMedications.add(item);
                              } else {
                                type == 'allergy'
                                    ? _selectedAllergiesanddisease.remove(item)
                                    : _selectedMedications.remove(item);
                              }
                            });
                            Navigator.pop(context);
                          },
                        ))
                    .toList())
              ],
            ),
          );
        });
  }

  void showEditAllergiesBottomSheet(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    showModalBottomSheet(
        backgroundColor: AppColors.wh,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("내 알레르기 & 질병 수정",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: "알레르기나 질병 입력",
                          suffixIcon: SizedBox(
                            width: 12,
                            child: TextButton(
                              child: Text(
                                "추가 +",
                                style: TextStyle(
                                  color: AppColors.wh,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setModalState(() {});
                        },
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: _allergiesanddisease.where((allergy) {
                          return allergy.toLowerCase().contains(
                              textEditingController.text.toLowerCase());
                        }).map((filteredAllergy) {
                          bool isSelected = _selectedAllergiesanddisease
                              .contains(filteredAllergy);
                          return ChoiceChip(
                            label: Text(filteredAllergy),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setModalState(() {
                                if (selected && !isSelected) {
                                  _selectedAllergiesanddisease
                                      .add(filteredAllergy);
                                } else if (!selected && isSelected) {
                                  _selectedAllergiesanddisease
                                      .remove(filteredAllergy);
                                }
                              });
                            },
                            backgroundColor: AppColors.wh, // 비활성화 상태의 배경색
                            selectedColor: AppColors.wh, // 활성화 상태의 배경색
                            labelStyle: isSelected
                                ? TextStyle(
                                    color: Colors.black) // 선택됐을 때의 텍스트 스타일
                                : TextStyle(
                                    color: Colors.black), // 선택되지 않았을 때의 텍스트 스타일
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    color: isSelected
                                        ? AppColors.vibrantTeal
                                        : AppColors
                                            .gr300) // 선택 여부에 따라 테두리 색상 변경
                                ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // 닫기 전에 상태 업데이트
                          setState(() {}); // InfoSection 업데이트를 위한 상태 갱신
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.softTeal,
                          minimumSize: Size(double.infinity, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "저장하기",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'pretendard',
                            color: AppColors.vibrantTeal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void showEditMedicationsBottomSheet(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    showModalBottomSheet(
        backgroundColor: AppColors.wh,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("내가 복용 중인 약 수정",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: "복용중인 약 이름 입력",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              // 추후 추가 기능 구현
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setModalState(() {});
                        },
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: _medications.where((medication) {
                          return medication.toLowerCase().contains(
                              textEditingController.text.toLowerCase());
                        }).map((filteredMedication) {
                          bool isSelected =
                              _selectedMedications.contains(filteredMedication);
                          return ChoiceChip(
                            label: Text(filteredMedication),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setModalState(() {
                                if (selected && !isSelected) {
                                  _selectedMedications.add(filteredMedication);
                                } else if (!selected && isSelected) {
                                  _selectedMedications
                                      .remove(filteredMedication);
                                }
                              });
                            },
                            backgroundColor: AppColors.wh, // 비활성화 상태의 배경색
                            selectedColor: AppColors.wh, // 활성화 상태의 배경색
                            labelStyle: isSelected
                                ? TextStyle(
                                    color: Colors.black) // 선택됐을 때의 텍스트 스타일
                                : TextStyle(
                                    color: Colors.black), // 선택되지 않았을 때의 텍스트 스타일
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    color: isSelected
                                        ? AppColors.vibrantTeal
                                        : AppColors
                                            .gr300) // 선택 여부에 따라 테두리 색상 변경
                                ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // 닫기 전에 상태 업데이트
                          setState(() {}); // InfoSection 업데이트를 위한 상태 갱신
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.softTeal,
                          minimumSize: Size(double.infinity, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "저장하기",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'pretendard',
                            color: AppColors.vibrantTeal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Widget buildInfoSection(
      BuildContext context, String title, String prompt, String type) {
    List<String> selectedItems =
        type == 'allergy' ? _selectedAllergiesanddisease : _selectedMedications;
    Function showEditSheet = type == 'allergy'
        ? showEditAllergiesBottomSheet
        : showEditMedicationsBottomSheet;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.gr150,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: selectedItems
                .map(
                  (item) => Chip(
                    backgroundColor: AppColors.vibrantTeal,
                    label: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        color: AppColors.wh,
                      ),
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.vibrantTeal),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (title == '내가 복용 중인 약') {
                // Navigate to a different screen if the title is '내가 복용 중인 약'
                navigateToCategory();
              } else {
                // Show the edit sheet for other titles
                showEditSheet(context);
              }
            },            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 36),
              backgroundColor: AppColors.wh,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '수정하기',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
    body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              buildProfileHeader(),
              SizedBox(height: 60),
              Wrap(
                children: [
                  buildInfoSection(context, '내 알레르기 및 질병',
                      "알레르기 및 질병 정보를 입력하세요.", 'allergy'),
                  buildInfoSection(context, '내가 복용 중인 약', "복용 중인 약 정보를 입력하세요.",
                      'medication'),
                ],
              ),
            ],
          ),
        ),
      */
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 60),
          buildProfileHeader(),
          const SizedBox(height: 60),
          buildInfoSection(
              context, '내 알레르기 및 질병', "알레르기 및 질병 정보를 입력하세요.", 'allergy'),
          buildInfoSection(
              context, '내가 복용 중인 약', "복용 중인 약 정보를 입력하세요.", 'medication'),
          buildPageNavigationSection(context),
        ],
      ),
    );
  }

  Widget buildProfileHeader() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 40),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.gr200,
            child: Image.asset('assets/user-icon.png', width: 70, height: 70),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, right: 100),
                child: Text(
                  '${memberInfo?['name']} 님',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () {
                  print("정보 수정 기능 구현 필요");
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(top: 10, right: 125),
                ),
                child: Text('정보 수정',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      color: AppColors.gr550,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPageNavigationSection(BuildContext context) {
    final APIClient apiClient = APIClient();
    return Column(
      children: [
        buildNavigationItem(context, Icons.person, "멀티 프로필", () {
          // 멀티 프로필 페이지로 이동하는 기능 구현
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.star, "즐겨찾기", () {
          // 즐겨찾기 페이지로 이동하는 기능 구현
          navigateToFavorite();
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.history, "검색 히스토리", () {
          // 검색 히스토리 페이지로 이동하는 기능 구현
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.headset_mic, "고객센터", () {
          // 고객센터 페이지로 이동하는 기능 구현
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.settings, "환경설정", () {
          // 환경설정 페이지로 이동하는 기능 구현
          navigateToPreference();
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.logout, "로그아웃", () {
          // 로그아웃 기능 구현
        }),
      ],
    );
  }

  Widget buildNavigationItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.gr700),
      title: Text(
        title,
        style: AppTextStyles.body1S16.copyWith(color: AppColors.gr700),
      ),
      onTap: onTap,
    );
  }
}
