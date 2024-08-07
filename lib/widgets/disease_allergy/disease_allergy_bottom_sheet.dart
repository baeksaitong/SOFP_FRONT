import 'package:flutter/material.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/services/services_disease_allergy.dart';

class DiseaseAllergyBottomSheet extends StatefulWidget {
  final Function(List<String>) onSave;

  const DiseaseAllergyBottomSheet({required this.onSave, Key? key}) : super(key: key);

  @override
  _DiseaseAllergyBottomSheetState createState() => _DiseaseAllergyBottomSheetState();
}

class _DiseaseAllergyBottomSheetState extends State<DiseaseAllergyBottomSheet> {
  List<String> searchResults = [];
  List<String> selectedItems = [];
  String query = '';
  final DiseaseAllergyService diseaseAllergyService = DiseaseAllergyService();

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

  @override
  Widget build(BuildContext context) {
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
                    color: isSelected ? AppColors.gr800 : AppColors.gr800,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: isSelected ? AppColors.deepTeal : AppColors.gr400,
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
                onPressed: () => widget.onSave(selectedItems),
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
  }
}
