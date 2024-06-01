import 'package:flutter/material.dart';
import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';
import 'shapeSearch.dart';
import 'textSearch.dart'; // import for text search screen

void main() {
  runApp(MaterialApp(
    title: 'First App',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MedicationPage(),
  ));
}

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  List<String> medications = [
    '가디알정50밀리그람',
    '가스디알50밀리그람',
    '가스디알정5밀리그람',
    '가스디알정50밀그람'
  ];
  bool isEditMode = false;
  Set<int> selectedIndexes = <int>{};
  String? selectedCategory; // 선택된 카테고리를 저장할 변수

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
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.gr150,
                    borderRadius: BorderRadius.circular(16.0), // 둥근 모서리를 만들기
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
                            // 알약 이름 검색 페이지로 이동
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
                          side: BorderSide.none, // 테두리 색상 설정
                          backgroundColor: AppColors.gr150,
                          minimumSize: Size(120, 100), // Adjust size as needed
                        ),
                        onPressed: () {
                          // 모양으로 검색 기능 구현
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
                              'assets/mdi_shape-plus.png', // 이미지 경로
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
                    Gaps.w10, // 버튼 사이의 간격
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide.none, // 테두리 색상 설정
                          backgroundColor: AppColors.gr150,
                          minimumSize: Size(120, 100), // Adjust size as needed
                        ),
                        onPressed: () {
                          // 카테고리 검색 기능 구현
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.category, // 카테고리 아이콘
                              size: 32,
                            ),
                            Gaps.h4,
                            Text(
                              '카테고리',
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

  void _showDeleteConfirmationDialog() {
    List<String> selectedMedications =
        selectedIndexes.map((index) => medications[index]).toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '알약 삭제',
            style: AppTextStyles.title3S18,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: selectedMedications.map((medication) {
              return Text('$medication을(를) 삭제하시겠습니까?',
                  style: AppTextStyles.caption1M12);
            }).toList(),
          ),
          actions: [
            TextButton(
              child: Text(
                '취소',
                style:
                    AppTextStyles.body5M14.copyWith(color: AppColors.deepTeal),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isEditMode = false;
                  selectedIndexes.clear();
                });
              },
            ),
            TextButton(
              child: Text(
                '확인',
                style:
                    AppTextStyles.body5M14.copyWith(color: AppColors.deepTeal),
              ),
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

  void _showMoveCategoryDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('이동하기', style: AppTextStyles.title3S18),
                  ListTile(
                    leading: Icon(Icons.folder, color: AppColors.deepTeal),
                    title: Text('카테고리1', style: AppTextStyles.body2M16),
                    selected: selectedCategory == '카테고리1',
                    selectedTileColor: AppColors.softTeal,
                    onTap: () {
                      setState(() {
                        selectedCategory = '카테고리1';
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.folder, color: AppColors.deepTeal),
                    title: Text('카테고리2', style: AppTextStyles.body2M16),
                    selected: selectedCategory == '카테고리2',
                    selectedTileColor: AppColors.softTeal,
                    onTap: () {
                      setState(() {
                        selectedCategory = '카테고리2';
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.folder, color: AppColors.deepTeal),
                    title: Text('카테고리3', style: AppTextStyles.body2M16),
                    selected: selectedCategory == '카테고리3',
                    selectedTileColor: AppColors.softTeal,
                    onTap: () {
                      setState(() {
                        selectedCategory = '카테고리3';
                      });
                    },
                  ),
                  Gaps.h20,
                  ElevatedButton(
                    onPressed: selectedCategory == null
                        ? null
                        : () {
                            // 이동 기능 최종 구현
                            Navigator.of(context).pop();
                            setState(() {
                              isEditMode = false;
                              selectedIndexes.clear(); // 선택된 인덱스 초기화
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: selectedCategory == null
                          ? AppColors.gr250
                          : AppColors.deepTeal,
                    ),
                    child: Text('이동',
                        style: AppTextStyles.body1S16
                            .copyWith(color: AppColors.wh)),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        isEditMode = false;
      });
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
                          'assets/exPill.png',
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
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: AppColors.gr250,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('삭제',
                          style: AppTextStyles.body1S16
                              .copyWith(color: AppColors.gr600)),
                    ),
                  ),
                  Gaps.w10,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedIndexes.isEmpty
                          ? null
                          : () {
                              _showMoveCategoryDialog();
                            },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: selectedIndexes.isEmpty
                            ? AppColors.gr250
                            : AppColors.softTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('이동',
                          style: AppTextStyles.body1S16
                              .copyWith(color: AppColors.deepTeal)),
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
                        backgroundColor: AppColors.gr250,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        '편집',
                        style: AppTextStyles.body1S16
                            .copyWith(color: AppColors.gr600),
                      ),
                    ),
                  ),
                  Gaps.w10,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showAddMedicationDialog,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: AppColors.softTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        '추가',
                        style: AppTextStyles.body1S16
                            .copyWith(color: AppColors.deepTeal),
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
