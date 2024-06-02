import 'package:flutter/material.dart';
import 'appTextStyles.dart'; // 원하는 글꼴 스타일이 정의된 파일을 임포트
import 'appColors.dart';
import 'gaps.dart';
import 'navigates.dart';
import 'shapeSearch.dart';
import 'textSearch.dart';

class MedicationCategoryPage extends StatelessWidget {
  final Map<String, dynamic> category;

  const MedicationCategoryPage({super.key, required this.category});

  void _showAddMedicationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.wh,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('카테고리 알약 추가', style: AppTextStyles.title1B24),
                Gaps.h20,
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.gr150,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            elevation: 0,
                            side: BorderSide.none,
                            backgroundColor: AppColors.gr150,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TextSearch(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.search,
                                color: AppColors.gr500,
                              ),
                              Gaps.w10,
                              Text(
                                '알약 이름을 검색해 보세요',
                                style: AppTextStyles.body5M14
                                    .copyWith(color: AppColors.gr500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.h20,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide.none,
                          backgroundColor: AppColors.gr150,
                          minimumSize: Size(120, 100),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShapeSearch(),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/mdi_shape-plus.png',
                              width: 32,
                              height: 32,
                            ),
                            Gaps.h4,
                            Text(
                              '모양으로 검색',
                              style: AppTextStyles.body5M14
                                  .copyWith(color: AppColors.bk),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gaps.w10,
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide.none,
                          backgroundColor: AppColors.gr150,
                          minimumSize: Size(120, 100),
                        ),
                        onPressed: () {
                          navigateToMedicationsTakingPlus(context,
                              (newCategory) {
                            // Update the category with the new data
                            // This part should be customized according to how you want to handle the added category
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                // 이미지로 검색 기능 구현
                              },
                              icon: Image.asset(
                                'assets/majesticons_camera.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            Gaps.h2,
                            Text(
                              '사진으로 검색',
                              style: AppTextStyles.body5M14
                                  .copyWith(color: AppColors.bk),
                            ),
                          ],
                        ),
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
  }

  @override
  Widget build(BuildContext context) {
    // Ensure medications is of the correct type
    final List<Map<String, String>> medications =
        List<Map<String, String>>.from(category['medications'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('복용중인 알약', style: AppTextStyles.body1S16),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: AppColors.wh,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${category['name']}',
                          style: AppTextStyles.title1B24,
                        ),
                        Gaps.w4,
                        const Icon(Icons.circle, color: Colors.red, size: 10),
                      ],
                    ),
                    Gaps.h8,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text(
                            '섭취 요일: ${category['days']?.join(', ')}',
                            style: AppTextStyles.body2M16
                                .copyWith(color: AppColors.gr800),
                          ),
                          Gaps.h8,
                          Text(
                            '섭취 시간: ${category['times']?.join(', ')}',
                            style: AppTextStyles.body2M16
                                .copyWith(color: AppColors.gr800),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            Gaps.h16,
            Expanded(
              child: ListView.builder(
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  final medication = medications[index];
                  return Card(
                    color: AppColors.wh,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.asset(medication['image']!),
                      title: Text(medication['name']!,
                          style: AppTextStyles.body1S16),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('제품명: ${medication['name']}'),
                          Text('제조회사: ${medication['manufacturer']}'),
                          Text('분류: ${medication['category']}'),
                        ],
                      ),
                      trailing: Icon(Icons.star, color: AppColors.deepTeal),
                      isThreeLine: true,
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _showAddMedicationDialog(context);
                  },
                  child: Text(
                    '추가',
                    style:
                        AppTextStyles.body3S15.copyWith(color: AppColors.gr800),
                  ),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    navigateToMedicationsTakingPlus(context, (updatedCategory) {
                      // Update the category with new data
                    }, category);
                  },
                  child: Text(
                    '수정',
                    style:
                        AppTextStyles.body3S15.copyWith(color: AppColors.gr800),
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
