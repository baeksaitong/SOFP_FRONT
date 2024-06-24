// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

// Project imports:
import '../../constans/colors.dart';
import '../../constans/text_styles.dart';
import '../../constans/gaps.dart';
import '../../navigates.dart';
import '../../providers/provider.dart';

import '../../managers/jwtManager.dart'; // JWTmanager 클래스가 정의된 파일을 import

class AddAllergyPage extends StatefulWidget {
  const AddAllergyPage({super.key});

  @override
  _AddAllergyPageState createState() => _AddAllergyPageState();
}

class _AddAllergyPageState extends State<AddAllergyPage> {
  List<String> searchResults = [];
  List<String> selectedItems = [];
  List<String> allergies = [];
  String query = '';
  final Dio _dio = Dio(); // Dio 인스턴스 생성
  final JWTmanager _jwtManager = JWTmanager(); // JWTmanager 인스턴스 생성

  @override
  void initState() {
    super.initState();
    _loadAllergies();
  }

  Future<void> _loadAllergies() async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    if (currentProfile == null) return;

    try {
      final accessToken = await _jwtManager.getValidAccessToken();
      final response = await _dio.get(
        'http://15.164.18.65:8080/app/disease-allergy/${currentProfile.id}',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          allergies = List<String>.from(response.data['DiseaseAllergyList']);
        });
      }
    } catch (e) {
      print('Error loading allergies: $e');
    }
  }

  Future<void> onSearch(String value) async {
    setState(() {
      query = value;
    });

    try {
      final accessToken = await _jwtManager.getValidAccessToken();
      final response = await _dio.get(
        'http://15.164.18.65:8080/app/disease-allergy/search',
        queryParameters: {'keyword': query},
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          searchResults = List<String>.from(response.data['DiseaseAllergyList']);
        });
      }
    } catch (e) {
      print('Error searching allergies: $e');
    }
  }

  void toggleSelection(String item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  Future<void> saveSelections() async {
    try {
      final accessToken = await _jwtManager.getValidAccessToken();
      final response = await _dio.patch(
        'http://15.164.18.65:8080/app/disease-allergy/${Provider.of<ProfileProvider>(context, listen: false).currentProfile?.id}',
        data: {
          'addDiseaseAllergyList': selectedItems,
          'removeDiseaseAllergyList': []
        },
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          allergies.addAll(selectedItems);
          selectedItems.clear();
        });
        print('Allergies saved successfully');
        Navigator.of(context).pop(true); // 데이터를 새로고침하도록 true 반환
      } else {
        print('Failed to save allergies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving allergies: $e');
    }
  }

  Future<void> saveSelectionsAndNavigate() async {
    print('saveSelectionsAndNavigate called');
    try {
      final accessToken = await _jwtManager.getValidAccessToken();
      final response = await _dio.patch(
        'http://15.164.18.65:8080/app/disease-allergy/${Provider.of<ProfileProvider>(context, listen: false).currentProfile?.id}',
        data: {
          'addDiseaseAllergyList': selectedItems,
          'removeDiseaseAllergyList': []
        },
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );

      if (response.statusCode == 200) {
        print('Successfully saved allergies');
        setState(() {
          allergies.addAll(selectedItems);
          selectedItems.clear();
        });
        navigateToHome();
      } else {
        print('Failed to save allergies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving allergies: $e');
    }
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.wh,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('알레르기 & 질병 추가', style: AppTextStyles.title1B24),
                    Gaps.h20,
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: selectedItems.map((item) {
                        return Chip(
                          backgroundColor: AppColors.gr300,
                          labelStyle: TextStyle(color: AppColors.gr800),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: AppColors.gr300),
                          ),
                          label: Text(item),
                          onDeleted: () {
                            setState(() {
                              selectedItems.remove(item);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    Gaps.h20,
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                        onSearch(value); // 자동완성 검색
                      },
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: true,
                        fillColor: AppColors.gr250,
                        hintText: '질병 또는 알레르기를 검색해 보세요',
                        hintStyle: AppTextStyles.body5M14,
                      ),
                    ),
                    Gaps.h20,
                    // 검색 결과를 보여주는 부분
                    searchResults.isNotEmpty
                        ? Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: searchResults.map((item) {
                        bool isSelected = selectedItems.contains(item);
                        return FilterChip(
                          label: Text(item),
                          selected: isSelected,
                          onSelected: (bool value) {
                            setState(() {
                              toggleSelection(item);
                            });
                          },
                          backgroundColor: AppColors.gr150,
                          selectedColor: AppColors.wh,
                          checkmarkColor: AppColors.deepTeal,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.gr800
                                : AppColors.gr800,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.deepTeal
                                  : AppColors.gr400,
                            ),
                          ),
                        );
                      }).toList(),
                    )
                        : Container(),
                    Gaps.h20,
                    Gaps.h20,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: saveSelections,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.deepTeal,
                          backgroundColor: AppColors.softTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          '저장하기',
                          style: AppTextStyles.body1S16.copyWith(color: AppColors.deepTeal),
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

  @override
  Widget build(BuildContext context) {
    final currentProfile = Provider.of<ProfileProvider>(context).currentProfile;
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.wh,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${currentProfile?.name}님 환영합니다!',
              style: AppTextStyles.title1B24,
            ),
            SizedBox(height: 10),
            Text(
              '현재 앓고 있는 질병 및 알레르기가 있다면 추가해 주세요!',
              style: AppTextStyles.body2M16,
            ),
            SizedBox(height: 20),
            Text(
              '질병 및 알레르기',
              style: AppTextStyles.body2M16,
            ),
            Gaps.h10,
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: allergies.map((allergy) {
                return Chip(
                  label: Text(allergy),
                  onDeleted: () {
                    setState(() {
                      allergies.remove(allergy);
                    });
                  },
                  backgroundColor: AppColors.wh,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.vibrantTeal),
                  ),
                );
              }).toList(),
            ),
            Gaps.h10,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.gr250,
              ),
              child: TextButton(
                onPressed: showBottomSheet,
                child: Text(
                  '+ 추가하기',
                  style: AppTextStyles.body2M16.copyWith(color: AppColors.gr600),
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('약속 시작하기 버튼 클릭됨');
                  saveSelectionsAndNavigate();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.deepTeal,
                  backgroundColor: AppColors.softTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '약속 시작하기',
                  style: AppTextStyles.body1S16.copyWith(color: AppColors.deepTeal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
