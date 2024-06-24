// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:sopf_front/managers/globalResponseManager.dart';
import 'package:sopf_front/providers/provider.dart';
import '../../managers/apiClient.dart';
import '../../constans/colors.dart';
import '../../constans/gaps.dart';
import '../../navigates.dart';
import '../search/search_shape.dart';
import '../search/search_text.dart';

import '../../constans/text_styles.dart'; // 원하는 글꼴 스타일이 정의된 파일을 임포트

class MedicationCategoryPage extends StatefulWidget {
  final CategoryDetails category;

  const MedicationCategoryPage({super.key, required this.category});

  @override
  State<MedicationCategoryPage> createState() => _MedicationCategoryPageState();
}

class _MedicationCategoryPageState extends State<MedicationCategoryPage> {
  bool isEditMode = false;
  Set<int> selectedIndexes = <int>{};
  String? selectedCategoryName;
  Category? selectedCategoryDetails;

  List<TakingDrugsInfo> medications = [];
  List<Category> categories = [];

  final APIClient apiClient = APIClient();

  @override
  void initState() {
    super.initState();
    _initializeMedications();
    _initializeCatories();
  }

  void _initializeMedications() async {
    print('categoryId:${widget.category.id}');
    await apiClient.pillGet(context, widget.category.id);
    setState(() {
      medications = TakingDrugsManager().drugs;
      print(medications);
    });
  }

  void _initializeCatories() async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    await apiClient.categoryGetAll(context, currentProfile!.id);
    setState(() {
      categories = CategoryManager().categories;
      print(categories);
    });
  }

  void _showAddMedicationDialog() {
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
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                            navigateToTextSearchDetail();
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
                                style: AppTextStyles.body5M14.copyWith(color: AppColors.gr500),
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
                          side: BorderSide.none,
                          backgroundColor: AppColors.gr150,
                          minimumSize: Size(120, 100),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShapeSearchPage(),
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
                              style: AppTextStyles.body5M14.copyWith(color: AppColors.bk),
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
                          navigateToMedicationsTakingPlus(context, (newCategory) {
                            setState(() {
                              // newCategory['medications'] = <Map<String, String>>[]; // Ensure the medications field is initialized
                              // categories.add(newCategory);
                              // selectedCategoryName = newCategory['name'];
                              // selectedCategoryDetails = newCategory;
                            });
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.category,
                              size: 32,
                            ),
                            Gaps.h4,
                            Text(
                              '카테고리',
                              style: AppTextStyles.body5M14.copyWith(color: AppColors.bk),
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
    List<TakingDrugsInfo> selectedMedications =
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
              return Text('${medication.name}을(를) 삭제하시겠습니까?',
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

  void _removeSelectedMedications() async {
    for (int index in selectedIndexes) {
      await apiClient.pillDelete(context, medications[index].serialNumber);
    }
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
                  for (Category category in categories)
                    ListTile(
                      leading: Icon(Icons.folder, color: AppColors.deepTeal),
                      title:
                      Text(category.name, style: AppTextStyles.body2M16),
                      selected: selectedCategoryName == category.name,
                      selectedTileColor: AppColors.softTeal,
                      onTap: () async {

                        setState(() {
                          selectedCategoryName = category.name;
                          selectedCategoryDetails = category;
                        });
                      },
                    ),
                  ListTile(
                    leading: Icon(Icons.add, color: AppColors.deepTeal),
                    title: Text('카테고리 추가하기', style: AppTextStyles.body2M16),
                    onTap: () {
                      navigateToMedicationsTakingPlus(context, (newCategory) {
                        setState(() {
                          // categories.add(newCategory);
                          // selectedCategoryName = newCategory['name'];
                          // selectedCategoryDetails = newCategory;
                        });
                      });
                    },
                  ),
                  Gaps.h20,
                  ElevatedButton(
                    onPressed: selectedCategoryName == null
                        ? null
                        : () async {
                      print('이동하기 클릭 : ${selectedCategoryDetails!.categoryId}');
                      for (int index in selectedIndexes) {
                        print(index);
                        await apiClient.pillPatch(context, medications[index].serialNumber, selectedCategoryDetails!.categoryId);
                      }
                      _moveSelectedMedications();
                      Navigator.of(context).pop();
                      navigateToMedicationsTaking();
                      setState(() {
                        isEditMode = false;
                        selectedIndexes.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: selectedCategoryName == null
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

  void _moveSelectedMedications() {
    if (selectedCategoryDetails != null) {
      final selectedMedications =
      selectedIndexes.map((index) => medications[index]).toList();
      setState(() {
        // selectedCategoryDetails!['medications'].addAll(selectedMedications.map((medication) => {
        //   'name': medication.name,
        //   'manufacturer': medication.enterprise,
        //   'category': medication.classification,
        //   'image': medication.imgUrl,
        // }));
        selectedIndexes.clear();
      });
    }
  }

  String formatTime(String time) {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = timeParts[1];
    return '$hour시 $minute분';
  }

  String getKoreanDay(String day) {
    switch (day) {
      case 'MON':
        return '월';
      case 'TUE':
        return '화';
      case 'WED':
        return '수';
      case 'THU':
        return '목';
      case 'FRI':
        return '금';
      case 'SAT':
        return '토';
      case 'SUN':
        return '일';
      default:
        return day;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.category.name, style: AppTextStyles.title1B24),
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Text(
                                  '카테고리 내 알약들도 삭제하시겠습니까?',
                                  style: AppTextStyles.body2M16,
                                  selectionColor: AppColors.gr800,
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  OutlinedButton(
                                    onPressed: () async {
                                      await apiClient.categoryDelete(context, widget.category.id, false);
                                      navigateToMedicationsTaking();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: AppColors.gr250,
                                      minimumSize: Size(120, 44),
                                      side: BorderSide.none,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                      ),
                                    ),
                                    child: Text(
                                      '알약 유지',
                                      style: AppTextStyles.body1S16,
                                      selectionColor: AppColors.gr600,
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () async {
                                      await apiClient.categoryDelete(context, widget.category.id, false);
                                      navigateToMedicationsTaking();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: AppColors.softTeal,
                                      minimumSize: Size(120, 44),
                                      side: BorderSide.none,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                      ),
                                    ),
                                    child: Text(
                                      '전체 삭제',
                                      style: AppTextStyles.body1S16.copyWith(color: AppColors.gr600),
                                      selectionColor: AppColors.deepTeal,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gr150,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '삭제',
                          style: AppTextStyles.body4S14.copyWith(color: AppColors.red),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.gr150,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('섭취 시간', style: AppTextStyles.body1S16),
                            SizedBox(height: 8),
                            Text(
                              widget.category.intakeDayList.map((day) => getKoreanDay(day)).join(', '),
                              style: AppTextStyles.body5M14,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.category.intakeTimeList
                                  .map((time) => Text(formatTime(time), style: AppTextStyles.body5M14))
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  final medication = medications[index];
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            medications[index].imgUrl,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medications[index].name,
                                style: AppTextStyles.body1S16,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '제조사: ${medications[index].enterprise}',
                                style: AppTextStyles.body5M14,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '분류: ${medications[index].classification}',
                                style: AppTextStyles.body5M14,
                                overflow: TextOverflow.ellipsis,
                              ),
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
