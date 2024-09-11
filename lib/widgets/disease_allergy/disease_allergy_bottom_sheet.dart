import 'dart:async';
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

  // Debounce 타이머
  Timer? _debounce;

  // 페이징 관련 변수
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
    _debounce?.cancel(); // 타이머 해제
    super.dispose();
  }

  // 검색어 입력에 대한 처리 (debounce 적용)
  Future<void> onSearch(String value) async {
    // 기존 타이머 취소
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // 타이머 설정 (300ms 동안 입력이 없으면 검색)
    _debounce = Timer(Duration(milliseconds: 300), () {
      setState(() {
        query = value;
        currentPage = 1;
        searchResults.clear(); // 이전 검색 결과 제거
        hasMoreData = true;
      });

      _performSearch(); // 검색 수행
    });
  }

  // 검색 수행
  Future<void> _performSearch() async {
    print('검색어: $query');
    try {
      final result = await diseaseAllergyService.diseaseAllergySearch(query, page: currentPage, pageSize: pageSize);
      setState(() {
        searchResults = result ?? [];
        currentPage++;
        hasMoreData = result != null && result.length == pageSize; // 더 가져올 데이터가 있는지 확인
      });
    } catch (e) {
      print('Error searching allergies: $e');
    }
  }

  // 추가 데이터를 로드하는 함수
  Future<void> _loadMoreData() async {
    if (!isLoadingMore && hasMoreData) {
      setState(() {
        isLoadingMore = true;
      });

      try {
        final result = await diseaseAllergyService.diseaseAllergySearch(query, page: currentPage, pageSize: pageSize);
        setState(() {
          searchResults.addAll(result ?? []); // 새 데이터 추가
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

  // 스크롤 끝에 도달했을 때 추가 데이터를 요청하는 리스너
  void _scrollListener() {
    if (_scrollController.position.extentAfter < 300) {
      _loadMoreData();
    }
  }

  // 선택된 항목을 토글하는 함수
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
      child: SingleChildScrollView(
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
              // 검색 결과를 보여주는 부분
              searchResults.isNotEmpty
                  ? SizedBox(
                height: 400, // 검색 결과가 스크롤될 수 있는 높이 설정
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 한 줄에 2개의 아이템을 표시
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 4, // 너비 대비 높이 비율
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
      ),
    );
  }
}
