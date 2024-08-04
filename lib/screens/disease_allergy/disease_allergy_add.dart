// lib/screens/disease_allergy/disease_allergy_add.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/providers/provider.dart';
import 'package:sopf_front/managers/managers_jwt.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/home.dart';

class DiseaseAllergyAdd extends StatefulWidget {
  @override
  _DiseaseAllergyAddState createState() => _DiseaseAllergyAddState();
}

class _DiseaseAllergyAddState extends State<DiseaseAllergyAdd> {
  List<String> searchResults = [];
  List<String> selectedItems = [];
  List<String> allergies = [];
  String query = '';
  final Dio _dio = Dio(); // Dio 인스턴스 생성
  final JWTManager _jwtManager = JWTManager(); // JWTmanager 인스턴스 생성

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
        Navigator.of(context).pop(true);
      } else {
        print('Failed to save allergies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving allergies: $e');
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      // Add your bottom sheet content here
                    ),
                  );
                },
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
                  saveSelections();
                  navigateToHome();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepTeal,
                  foregroundColor: AppColors.softTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '약속 시작하기',
                  style: AppTextStyles.body1S16.copyWith(color: AppColors.wh),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
