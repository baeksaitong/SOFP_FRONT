import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider 추가
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

  Timer? _debounce;

  int currentPage = 1;
  final int pageSize = 30;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // 검색어 입력에 대한 처리 (debounce 적용)
  Future<void> onSearch(String value) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 100), () {
      setState(() {
        query = value;
        currentPage = 1;
        searchResults.clear();
        hasMoreData = true;
      });
      if (query.isNotEmpty) {
        _performSearch();
      }
    });
  }

  Future<void> _performSearch() async {
    try {
      final result = await diseaseAllergyService.diseaseAllergySearch(query, page: currentPage, pageSize: pageSize);
      setState(() {
        searchResults = result ?? [];
        currentPage++;
        hasMoreData = result != null && result.length == pageSize;
      });
    } catch (e) {
      print('Error searching allergies: $e');
    } finally {
    }
  }

  Future<void> _loadMoreData() async {
    if (!isLoadingMore && hasMoreData) {
      setState(() {
        isLoadingMore = true;
      });
      try {
        final result = await diseaseAllergyService.diseaseAllergySearch(query, page: currentPage, pageSize: pageSize);
        setState(() {
          searchResults.addAll(result ?? []);
          currentPage++;
          hasMoreData = result != null && result.length == pageSize;
        });
      } catch (e) {
        print('Error loading more data: $e');
      } finally {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 300) {
      _loadMoreData();
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
    return Stack(
      children: [
        Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            controller: _scrollController,
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
                      onSearch(value); // 검색어 입력 시 검색 시작
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
                  searchResults.isNotEmpty
                      ? SizedBox(
                    height: 400,
                    child: GridView.builder(
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 4,
                      ),
                      itemCount: searchResults.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == searchResults.length) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final item = searchResults[index];
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
                      },
                    ),
                  )
                      : Container(),
                  Gaps.h20,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onSave(selectedItems);
                        Navigator.pop(context);
                      },
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
          ),
        ),
      ],
    );
  }
}
