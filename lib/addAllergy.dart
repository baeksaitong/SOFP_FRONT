import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';
import 'provider.dart';
import 'navigates.dart';

class AddAllergyPage extends StatefulWidget {
  const AddAllergyPage({super.key});

  @override
  _AddAllergyPageState createState() => _AddAllergyPageState();
}

class _AddAllergyPageState extends State<AddAllergyPage> {
  List<String> searchResults = ['알러지1', '알러지2', '알러지3', '새우', '장구'];
  List<String> selectedItems = [];
  List<String> allergies = []; // Initialize the allergies list
  String query = '';

  void onSearch(String value) {
    setState(() {
      query = value;
      // Simulate search results based on the query
      searchResults = ['알러지1', '알러지2', '알러지3', '새우', '장구']
          .where((item) => item.contains(query))
          .toList();
    });
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

  void saveSelections() {
    setState(() {
      // Add the selected items to the list of allergies
      for (var item in selectedItems) {
        if (!allergies.contains(item)) {
          allergies.add(item);
        }
      }
    });
    Navigator.of(context).pop();
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
                    Text('선택된 항목', style: AppTextStyles.body2M16),
                    Gaps.h10,
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
                    Text('알레르기 & 질병 추가하기', style: AppTextStyles.title1B24),
                    Gaps.h10,
                    TextField(
                      onChanged: onSearch,
                      decoration: InputDecoration(
                        hintText: '질병 또는 알레르기를 검색해 보세요',
                        hintStyle: AppTextStyles.body5M14,
                      ),
                    ),
                    Gaps.h10,
                    Text('연관 검색어', style: AppTextStyles.body2M16),
                    Gaps.h10,
                    Wrap(
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
                            color:
                                isSelected ? AppColors.gr800 : AppColors.gr800,
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
                    ),
                    Gaps.h20,
                    Gaps.h20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: saveSelections,
                          child: Text(
                            '저장하기',
                            style: AppTextStyles.body5M14,
                          ),
                        ),
                      ],
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
      appBar: AppBar(),
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
              children: allergies.map((item) {
                return Chip(
                  backgroundColor: AppColors.softTeal,
                  labelStyle: TextStyle(color: AppColors.deepTeal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: AppColors.softTeal),
                  ),
                  label: Text(item),
                  onDeleted: () {
                    setState(() {
                      allergies.remove(item);
                    });
                  },
                );
              }).toList(),
            ),
            Gaps.h10,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.gr150,
              ),
              child: TextButton(
                onPressed: showBottomSheet,
                child: Text(
                  '+ 추가하기',
                  style:
                      AppTextStyles.body2M16.copyWith(color: AppColors.gr600),
                ),
              ),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.softTeal,
              ),
              child: ElevatedButton(
                onPressed: () {
                  navigateToHome();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.deepTeal,
                  backgroundColor: AppColors.softTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '바로 시작하기',
                  style: AppTextStyles.body1S16
                      .copyWith(color: AppColors.deepTeal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
