// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:sopf_front/managers/managers_api_client.dart';
import 'package:sopf_front/managers/managers_global_response.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/providers/provider.dart';
import '../../constans/colors.dart';
import '../../constans/text_styles.dart';
import '../../constans/gaps.dart';
import '../search/search_shape.dart';
import '../search/search_text.dart';

class PillTaskingList extends StatefulWidget {
  const PillTaskingList({super.key});

  @override
  _PillTaskingListState createState() => _PillTaskingListState();
}

class _PillTaskingListState extends State<PillTaskingList> {
  List<TakingDrugsInfo> medications = [];
  bool isEditMode = false;
  Set<int> selectedIndexes = <int>{};
  String? selectedCategoryName;
  Category? selectedCategoryDetails;
  List<Category> categories = [];

  final APIClient apiClient = APIClient();

  @override
  void initState() {
    super.initState();
    _initializeMedications();
    _initializeCategories();
  }

  void _initializeMedications() async {
    await apiClient.pillGet(context, null);
    setState(() {
      medications = TakingDrugsManager().drugs;
      print(medications);
    });
  }

  void _initializeCategories() async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    print('현재 프로필 : ${currentProfile?.id}');
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
            child: SingleChildScrollView(
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
                      print(
                          '이동하기 클릭 : ${selectedCategoryDetails!.categoryId}');
                      for (int index in selectedIndexes) {
                        print(index);
                        await apiClient.pillPatch(
                            context,
                            medications[index].serialNumber,
                            selectedCategoryDetails!.categoryId);
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

  void _editCategory(Category category) {
    navigateToMedicationsTakingPlus(
      context,
          (updatedCategory) {
        setState(() {
          int index =
          categories.indexWhere((cat) => cat.name == category.name);
          if (index != -1) {
            categories[index] = updatedCategory as Category;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        title: Text('복용중인 알약', style: AppTextStyles.title1B24),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.wh,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...categories.map((category) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // 패딩 제거
                          backgroundColor: Colors.transparent, // 배경색 제거
                          shadowColor: Colors.transparent, // 그림자 제거
                        ),
                        onPressed: () async {
                          await apiClient.categoryGet(
                              context, category.categoryId);
                          final CategoryDetails? categoryDetail =
                              CategoryDetailsManager().currentCategory;
                          navigateToMedicationCategory(
                              context, categoryDetail!);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.gr150,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/folder-filled.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  Gaps.w16,
                                  Text(category.name,
                                      style: AppTextStyles.title1B24
                                          .copyWith(color: AppColors.bk)),
                                ],
                              ),
                              Gaps.h8,
                            ],
                          ),
                        ),
                      ),
                      Gaps.h20,
                    ],
                  );
                }).toList(),
                ...medications.map((medication) {
                  int index = medications.indexOf(medication);
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
                            medication.imgUrl,
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
                                medication.name,
                                style: AppTextStyles.body1S16,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '제조사: ${medication.enterprise}',
                                style: AppTextStyles.body5M14,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '분류: ${medication.classification}',
                                style: AppTextStyles.body5M14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
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
        ),
      ),
    );
  }
}