import 'package:flutter/material.dart';
import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';
import 'textSearchForcategory.dart';
import 'shapeSearch.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  List<String> medications = [
    '가스디알정50밀리그람',
    '가스디알정50밀리그람',
    '가스디알정50밀리그람',
    '가스디알정50밀리그람'
  ];
  bool isEditMode = false;
  Set<int> selectedIndexes = <int>{};

  void _showAddMedicationDialog() {
    showModalBottomSheet(
      context: context,
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
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.text, // Add this line
                  textInputAction: TextInputAction.search, // Add this line
                  decoration: InputDecoration(
                    hintText: '약약 이름을 검색해 보세요',
                    hintStyle: AppTextStyles.body5M14,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
                        // 이미지로 검색 기능 구현
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TextSearchDetail(
                          initialSearchText: value,
                        ),
                      ),
                    );
                  },
                ),
                Gaps.h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shape_line),
                      onPressed: () {
                        // 모양으로 검색 기능 구현
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShapeSearch(),
                          ),
                        );
                      },
                      iconSize: 40,
                    ),
                    IconButton(
                      icon: Icon(Icons.category),
                      onPressed: () {
                        // 카테고리 검색 기능 구현
                      },
                      iconSize: 40,
                    ),
                  ],
                ),
                Gaps.h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        '취소',
                        style: AppTextStyles.body5M14,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Gaps.h20,
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    List<String> selectedMedications =
        selectedIndexes.map((index) => medications[index]).toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알약 삭제'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: selectedMedications.map((medication) {
              return Text('$medication을 삭제하시겠습니까?');
            }).toList(),
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isEditMode = false;
                  selectedIndexes.clear();
                });
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                _removeSelectedMedications();
                Navigator.of(context).pop();
                setState(() {
                  isEditMode = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _removeSelectedMedications() {
    setState(() {
      medications = medications
          .where((medication) =>
              !selectedIndexes.contains(medications.indexOf(medication)))
          .toList();
      selectedIndexes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('복용중인 알약', style: AppTextStyles.title1B24),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('감기약', style: AppTextStyles.title1B24),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.gr150,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('섭취 시간', style: AppTextStyles.body2M16),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // 편집 기능 추가
                        },
                      ),
                    ],
                  ),
                  Gaps.h8,
                  Text('월, 화, 수, 목, 금', style: AppTextStyles.body5M14),
                  SizedBox(height: 4),
                  Text('오전 8시 30분', style: AppTextStyles.body5M14),
                  Text('오후 1시 30분', style: AppTextStyles.body5M14),
                  Text('오후 7시 30분', style: AppTextStyles.body5M14),
                ],
              ),
            ),
            Gaps.h20,
            Expanded(
              child: ListView.builder(
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.wh,
                      border: Border(
                        left: BorderSide(
                          color: AppColors.softTeal,
                          width: 5,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        if (isEditMode)
                          Checkbox(
                            value: selectedIndexes.contains(index),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedIndexes.add(index);
                                } else {
                                  selectedIndexes.remove(index);
                                }
                              });
                            },
                          ),
                        Image.asset(
                          'assets/medication.png', // 약 이미지 경로
                          width: 50,
                          height: 50,
                        ),
                        Gaps.h16,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(medications[index],
                                  style: AppTextStyles.body1S16),
                              Text('제조사: 일동제약', style: AppTextStyles.body5M14),
                              Text('분류: 기타의 소화기관용약',
                                  style: AppTextStyles.body5M14),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.star_border),
                          onPressed: () {
                            // 즐겨찾기 기능 추가
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (isEditMode)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showDeleteConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('삭제',
                          style: AppTextStyles.body1S16
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                  Gaps.h10,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 이동 기능 추가
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.softTeal,
                      ),
                      child: Text('이동',
                          style: AppTextStyles.body1S16
                              .copyWith(color: AppColors.wh)),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditMode = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: AppColors.softTeal,
                      ),
                      child: Text(
                        '편집',
                        style: AppTextStyles.body1S16
                            .copyWith(color: AppColors.wh),
                      ),
                    ),
                  ),
                  Gaps.h10,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showAddMedicationDialog,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: AppColors.deepTeal,
                      ),
                      child: Text(
                        '추가',
                        style: AppTextStyles.body1S16
                            .copyWith(color: AppColors.wh),
                      ),
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
