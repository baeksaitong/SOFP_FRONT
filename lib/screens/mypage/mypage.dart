// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/managers/managers_taking_drugs.dart';

import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/services/services_disease_allergy.dart';
import 'package:sopf_front/services/services_pill.dart';
import '../../constans/gaps.dart';
import '../../managers/managers_jwt.dart';
import '../sign/sign_in.dart';
import 'mypage_edit.dart';
import 'mypage_profile_edit.dart';
import '../../providers/provider.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<String> allergiesanddisease = [];
  List<String> medications = [];
  final List<String> _selectedAllergiesanddisease = [];
  final List<String> _selectedMedications = [];
  Map<String, dynamic>? profile;

  final DiseaseAllergyService diseaseAllergyService = DiseaseAllergyService();
  final PillService pillService = PillService();

  Timer? _debounce;
  String query = '';

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final currentProfile = profileProvider.currentProfile;
      if (currentProfile != null) {
        setState(() {
          profile = currentProfile.toJson();
        });
        final fetchedAllergies = await diseaseAllergyService.diseaseAllergyList(context);
        setState(() {
          allergiesanddisease = fetchedAllergies ?? []; // null인 경우 빈 리스트 할당
        });
        await pillService.pillGet(context, null);
        setState(() {
          medications = TakingDrugsManager().drugs.map((drug) => drug.name).toList();
        });
      } else {
        logger.e('No current profile found.');
      }
    } catch (e) {
      logger.e('Error fetching profile: $e');
    }
  }

  Future<void> updateMedications() async {
    // _selectedMedications 리스트에 있는 알약의 serialNumber를 반복 처리
    for (String medication in _selectedMedications) {
      try {
        final int serialNumber = int.parse(medication); // serialNumber를 int로 변환

        // PillService의 pillPost 함수 호출
        await pillService.pillPost(context, serialNumber);

      } catch (e) {
        logger.e('Error adding medication with serial number $medication: $e');
      }
    }
  }

  void showEditAllergiesBottomSheet(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    List<String> searchResults = [];
    _selectedAllergiesanddisease.clear();
    _selectedAllergiesanddisease.addAll(allergiesanddisease);

    Future<void> onSearch(String value) async {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(Duration(milliseconds: 100), () async {
        setState(() {
          query = value;
          searchResults.clear();
        });
        if (query.isNotEmpty) {
          final searchAllergies = await diseaseAllergyService.diseaseAllergySearch(query);

          setState(() {
            searchResults= searchAllergies ?? [];
          });
        }
      });
    }

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
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          onSearch(value); // 실시간 검색
                        });
                      },
                    ),
                    Gaps.h10,
                    searchResults.isNotEmpty
                        ? Container(
                      height: 150,
                      child: ListView(
                        children: searchResults.map((item) {
                          bool isSelected = _selectedAllergiesanddisease.contains(item);
                          return ListTile(
                            title: Text(item),
                            trailing: isSelected
                                ? Icon(Icons.check_box)
                                : Icon(Icons.check_box_outline_blank),
                            onTap: () {
                              setModalState(() {
                                toggleSelection(item);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    )
                        : Container(),
                    Gaps.h20,
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // 닫기 전에 상태 업데이트
                        final List<String> removeDiseaseAllergyList = allergiesanddisease
                            .where((item) => !_selectedAllergiesanddisease.contains(item))
                            .toList();
                        diseaseAllergyService.diseaseAllergyAddOrDelete(
                            context,
                            _selectedAllergiesanddisease as String?,
                            removeDiseaseAllergyList as String?
                        );
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

  Future<void> showEditMedicationsBottomSheet(BuildContext context) async {
    TextEditingController textEditingController = TextEditingController();
    List<String> searchResults = [];
    _selectedMedications.clear();
    _selectedMedications.addAll(medications);

    Future<void> onSearch(String value) async {
      await pillService.pillGet(context, null);
      searchResults=TakingDrugsManager().drugs.cast<String>();
    }

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
                        setModalState(() {
                          onSearch(value); // 실시간 검색
                        });
                      },
                    ),
                    Gaps.h10,
                    searchResults.isNotEmpty
                        ? Container(
                      height: 150,
                      child: ListView(
                        children: searchResults.map((item) {
                          bool isSelected = _selectedMedications.contains(item);
                          return ListTile(
                            title: Text(item),
                            trailing: isSelected
                                ? Icon(Icons.check_box)
                                : Icon(Icons.check_box_outline_blank),
                            onTap: () {
                              setModalState(() {
                                toggleSelectionMedications(item);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    )
                        : Container(),
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

  void toggleSelection(String item) {
    setState(() {
      if (_selectedAllergiesanddisease.contains(item)) {
        _selectedAllergiesanddisease.remove(item);
      } else {
        _selectedAllergiesanddisease.add(item);
      }
    });
  }

  void toggleSelectionMedications(String item) {
    setState(() {
      if (_selectedMedications.contains(item)) {
        _selectedMedications.remove(item);
      } else {
        _selectedMedications.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final currentProfile = profileProvider.currentProfile;

    return Scaffold(
      backgroundColor: AppColors.wh,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Gaps.h60,
          buildProfileHeader(),
          Gaps.h60,
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
    final profileProvider = Provider.of<ProfileProvider>(context);
    final currentProfile = profileProvider.currentProfile;

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.gr200,
            backgroundImage: currentProfile?.imgURL != null && currentProfile!.imgURL!.isNotEmpty
                ? NetworkImage(currentProfile.imgURL!)
                : AssetImage('assets/mypageEdit/user-icon.png') as ImageProvider,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '${currentProfile?.name ?? '이름없음'} 님',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (currentProfile != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyPageEdit(profileId: currentProfile.id),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(left: 20),
                ),
                child: Text('회원정보 변경',
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
                      builder: (context) =>
                          MyPageProfileEdit(profileId: currentProfile?.id ?? ''),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                ),
                child: Text('프로필 정보 수정',
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

  Widget buildInfoSection(BuildContext context, String title, String prompt,
      String type) {
    List<String> selectedItems = type == 'allergy'
        ? allergiesanddisease
        : medications;
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
          Gaps.h10,
          Wrap(
            spacing: 8,
            children: selectedItems.map((item) {
              return Chip(
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
              );
            }).toList(),
          ),
          Gaps.h10,
          ElevatedButton(
            onPressed: () {
              if (title == '내가 복용 중인 약') {
                navigateToMedicationsTaking();
              } else {
                showEditSheet(context);
              }
            },
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

  Widget buildPageNavigationSection(BuildContext context) {
    return Column(
      children: [
        buildNavigationItem(context, Icons.person, "멀티 프로필", () {
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.star, "즐겨찾기", () {
          navigateToFavorite();
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.history, "검색 히스토리", () {
          navigateToRecentHistory();
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.headset_mic, "고객센터", () {
          navigateToCustomerService();
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.settings, "환경설정", () {
          navigateToPreference();
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.logout, "로그아웃", () {
          _logout(context);
        }),
      ],
    );
  }


  Future<void> _logout(BuildContext context) async {
    await JWTManager().deleteTokens();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
          (Route<dynamic> route) => false,
    );
  }

  Widget buildNavigationItem(BuildContext context, IconData icon, String title,
      VoidCallback onTap) {
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