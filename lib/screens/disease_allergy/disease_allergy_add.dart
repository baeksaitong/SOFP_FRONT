import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/providers/provider.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/home.dart';
import 'package:sopf_front/services/services_disease_allergy.dart';

import '../../widgets/disease_allergy/disease_allergy_bottom_sheet.dart';

class DiseaseAllergyAdd extends StatefulWidget {
  @override
  _DiseaseAllergyAddState createState() => _DiseaseAllergyAddState();
}

class _DiseaseAllergyAddState extends State<DiseaseAllergyAdd> {
  List<String> searchResults = [];
  List<String> selectedItems = [];
  List<String> allergies = [];
  String query = '';
  final DiseaseAllergyService diseaseAllergyService = DiseaseAllergyService();

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadAllergies();
  }

  Future<void> _loadAllergies() async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    if (currentProfile == null) return;

    try {
      final result = await DiseaseAllergyService().diseaseAllergyGet(context);
      setState(() {
        allergies = result ?? []; // null이면 빈 리스트를 사용
      });
    } catch (e) {
      logger.e('Error loading allergies: $e');
    }
  }

  Future<void> onSearch(String value) async {
    setState(() {
      query = value;
    });

    try {
      final result = await diseaseAllergyService.diseaseAllergySearch(query);
      setState(() {
        searchResults = result != null ? List<String>.from(result) : [];
      });
    } catch (e) {
      logger.e('Error searching allergies: $e');
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
      await diseaseAllergyService.diseaseAllergyAddOrDelete(
        context,
        allergies.isNotEmpty ? allergies.join(',') : null,
        null,
      );
      setState(() {
        allergies.addAll(selectedItems);
        selectedItems.clear();
      });
      Navigator.of(context).pop(true);
    } catch (e) {
      logger.e('Error saving allergies: $e');
    }

    navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    final currentProfile = Provider.of<ProfileProvider>(context).currentProfile;
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.wh,
        elevation: 0, // 그림자를 없애서 색 변화 방지
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
                  label: Text(
                    allergy,
                    style: AppTextStyles.body4S14.copyWith(color: Colors.white), // 글씨체를 body4S14로 설정하고 색상은 흰색으로 설정
                  ),
                  onDeleted: () {
                    setState(() {
                      allergies.remove(allergy);
                    });
                  },
                  backgroundColor: AppColors.vibrantTeal, // Chip의 배경색을 vibrantTeal로 설정
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
                    isScrollControlled: true, // To ensure it expands to full height if needed
                    builder: (context) => DiseaseAllergyBottomSheet(
                      onSave: (selectedItems) {
                        setState(() {
                          // 추가된 알레르기를 선택 항목에 추가
                          allergies.addAll(selectedItems);
                        });
                      },
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