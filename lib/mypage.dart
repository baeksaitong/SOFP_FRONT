import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sopf_front/customerServiceCenter.dart';
import 'package:sopf_front/globalResponseManager.dart';
import 'package:sopf_front/login.dart';
import 'package:sopf_front/multiProfileEdit.dart';
import 'mypageEdit.dart';
import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';
import 'provider.dart';
import 'jwtManager.dart';


class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<String> _allergiesanddisease = [];
  List<String> _medications = [];
  final List<String> _selectedAllergiesanddisease = [];
  final List<String> _selectedMedications = [];
  Map<String, dynamic>? memberInfo;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      final response = await http.get(Uri.parse('http://15.164.18.65:8080/app/member'));
      if (response.statusCode == 200) {
        setState(() {
          memberInfo = json.decode(response.body);
          print('User Info: $memberInfo'); // API 응답 출력
        });
        if (memberInfo != null) {
          final profile = Profile(
            id: memberInfo!['id'],
            name: memberInfo!['name'],
            imgURL: memberInfo!['imgURL'],
            color: memberInfo!['color'],
            email: '',
          );
          Provider.of<ProfileProvider>(context, listen: false).setCurrentProfile(profile);
        }
        await fetchAllergiesAndDiseases();
        await fetchMedications();
      } else {
        // 오류 처리
        print('Failed to load user info');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> fetchAllergiesAndDiseases() async {
    if (memberInfo != null && memberInfo!['id'] != null) {
      try {
        final response = await http.get(Uri.parse('http://15.164.18.65:8080/app/disease-allergy/${memberInfo!['id']}'));
        if (response.statusCode == 200) {
          setState(() {
            _allergiesanddisease = List<String>.from(json.decode(response.body)['DiseaseAllergyList']);
          });
        } else {
          // 오류 처리
          print('Failed to load allergies and diseases');
        }
      } catch (e) {
        print('Error fetching allergies and diseases: $e');
      }
    }
  }

  Future<void> fetchMedications() async {
    if (memberInfo != null && memberInfo!['id'] != null) {
      try {
        final response = await http.get(Uri.parse('http://15.164.18.65:8080/app/pill?profileId=${memberInfo!['id']}'));
        if (response.statusCode == 200) {
          setState(() {
            _medications = List<String>.from(json.decode(response.body)['pillInfoList'].map((pill) => pill['name']));
          });
        } else {
          // 오류 처리
          print('Failed to load medications');
        }
      } catch (e) {
        print('Error fetching medications: $e');
      }
    }
  }

  Future<void> updateAllergiesAndDiseases() async {
    try {
      final response = await http.patch(
        Uri.parse('http://15.164.18.65:8080/app/disease-allergy/${memberInfo!['id']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'addDiseaseAllergyList': _selectedAllergiesanddisease,
          'removeDiseaseAllergyList': _allergiesanddisease.where((item) => !_selectedAllergiesanddisease.contains(item)).toList(),
        }),
      );
      if (response.statusCode == 200) {
        fetchAllergiesAndDiseases(); // 업데이트 후 다시 불러오기
      } else {
        // 오류 처리
        print('Failed to update allergies and diseases');
      }
    } catch (e) {
      print('Error updating allergies and diseases: $e');
    }
  }

  Future<void> updateMedications() async {
    try {
      final response = await http.post(
        Uri.parse('http://15.164.18.65:8080/app/pill/${memberInfo!['id']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'pillSerialNumberList': _selectedMedications,
        }),
      );
      if (response.statusCode == 200) {
        fetchMedications(); // 업데이트 후 다시 불러오기
      } else {
        // 오류 처리
        print('Failed to update medications');
      }
    } catch (e) {
      print('Error updating medications: $e');
    }
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
                    Text("알레르기 & 질병 수정",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Gaps.h10,
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
                    Gaps.h10,
                    Wrap(
                      spacing: 8,
                      children: _allergiesanddisease.where((allergy) {
                        return allergy.toLowerCase().contains(textEditingController.text.toLowerCase());
                      }).map((filteredAllergy) {
                        bool isSelected = _selectedAllergiesanddisease.contains(filteredAllergy);
                        return ChoiceChip(
                          label: Text(filteredAllergy),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setModalState(() {
                              if (selected && !isSelected) {
                                _selectedAllergiesanddisease.add(filteredAllergy);
                              } else if (!selected && isSelected) {
                                _selectedAllergiesanddisease.remove(filteredAllergy);
                              }
                            });
                          },
                          backgroundColor: AppColors.wh,
                          selectedColor: AppColors.wh,
                          labelStyle: isSelected
                              ? TextStyle(color: Colors.black)
                              : TextStyle(color: Colors.black),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: isSelected ? AppColors.vibrantTeal : AppColors.gr300)),
                        );
                      }).toList(),
                    ),
                    Gaps.h20,
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // 닫기 전에 상태 업데이트
                        updateAllergiesAndDiseases(); // 서버로 업데이트 요청
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
      },
    );
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    Gaps.h10,
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
                    Gaps.h10,
                    Wrap(
                      spacing: 8,
                      children: _medications.where((medication) {
                        return medication.toLowerCase().contains(textEditingController.text.toLowerCase());
                      }).map((filteredMedication) {
                        bool isSelected = _selectedMedications.contains(filteredMedication);
                        return ChoiceChip(
                          label: Text(filteredMedication),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setModalState(() {
                              if (selected && !isSelected) {
                                _selectedMedications.add(filteredMedication);
                              } else if (!selected && isSelected) {
                                _selectedMedications.remove(filteredMedication);
                              }
                            });
                          },
                          backgroundColor: AppColors.wh,
                          selectedColor: AppColors.wh,
                          labelStyle: isSelected
                              ? TextStyle(color: Colors.black)
                              : TextStyle(color: Colors.black),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: isSelected ? AppColors.vibrantTeal : AppColors.gr300)),
                        );
                      }).toList(),
                    ),
                    Gaps.h20,
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // 닫기 전에 상태 업데이트
                        updateMedications(); // 서버로 업데이트 요청
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
      },
    );
  }

  Widget buildInfoSection(BuildContext context, String title, String prompt, String type) {
    List<String> selectedItems = type == 'allergy' ? _selectedAllergiesanddisease : _selectedMedications;
    Function showEditSheet = type == 'allergy' ? showEditAllergiesBottomSheet : showEditMedicationsBottomSheet;

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
          Gaps.h10,
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
          Gaps.h10,
          ElevatedButton(
            onPressed: () => showEditSheet(context),
            style: ElevatedButton.styleFrom(
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
    final currentProfile = Provider.of<ProfileProvider>(context).currentProfile;
    return Scaffold(
      backgroundColor: AppColors.wh,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Gaps.h60,
          buildProfileHeader(currentProfile),
          Gaps.h60,
          buildInfoSection(context, '내 알레르기 및 질병', "알레르기 및 질병 정보를 입력하세요.", 'allergy'),
          buildInfoSection(context, '내가 복용 중인 약', "복용 중인 약 정보를 입력하세요.", 'medication'),
          buildPageNavigationSection(context),
        ],
      ),
    );
  }

  Widget buildProfileHeader(Profile? profile) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.gr200,
            child: Image.asset('assets/user-icon.png', width: 100, height: 100),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '${profile?.name ?? '이름 없음'} 님',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (profile != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPageEdit(profile: profile),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(left: 20),
                ),
                child: Text('프로필 설정',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      color: AppColors.gr550,
                    )),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => multiProfileEdit(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                ),
                child: Text('회원정보 변경',
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
    return Column(
      children: [
        buildNavigationItem(context, Icons.person, "멀티 프로필", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => multiProfileEdit()),
          );
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.star, "즐겨찾기", () {
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.history, "검색 히스토리", () {
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.headset_mic, "고객센터", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomerServicePage()),
          );
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.settings, "환경설정", () {
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.logout, "로그아웃", () async {
          final jwtManager = JWTmanager();
          await jwtManager.deleteTokens();

          // 로그인 페이지로 리다이렉트
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
          );
        }),
      ],
    );
  }

  Widget buildNavigationItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
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
