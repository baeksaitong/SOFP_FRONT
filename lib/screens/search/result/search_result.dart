import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/managers/managers_drugs.dart';
import 'package:sopf_front/managers/managers_favorites.dart';
import 'package:sopf_front/models/models_drug_info.dart';
import 'package:sopf_front/models/models_favorite_info.dart';
import 'package:sopf_front/providers/provider.dart';
import 'package:sopf_front/screens/search/result/serach_result_pill_detail.dart';
import 'package:sopf_front/services/services_favortie.dart';
import 'package:sopf_front/services/services_search.dart';
import 'package:sopf_front/screens/search/search_shape.dart';

import '../../../navigates.dart';

class SearchResult extends StatefulWidget {
  final String searchKeyword; // 검색어 전달받음

  const SearchResult({super.key, required this.searchKeyword});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  ColorItem? selectedColorItem;
  ShapeItem? selectedShapeItem;
  FormulationItem? selectedFormulationItem;
  DivideLineItem? selectedDivideLineItem;

  String shapeText = '모양';
  String divideLineText = '분할선';
  String colorText = '색상';
  String formulationText = '제형';

  FavoriteService favoriteService = FavoriteService();
  SearchService searchService = SearchService();

  List<DrugInfo> drugs = [];
  List<FavoriteInfo> favorites = [];

  @override
  void initState() {
    super.initState();

    // TextEditingController에 초기 검색어 설정
    _controller.text = widget.searchKeyword; // 전달받은 검색어를 컨트롤러에 설정
    _initializeDrugs();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose(); // controller 해제
    super.dispose();
  }

  void _initializeDrugs() async {
    await favoriteService.favoriteGet(context);
    favorites = FavoritesManager().favorites;
    drugs = DrugsManager().drugs;
    for (var drug in drugs) {
      for (var favorite in favorites) {
        if (drug.serialNumber == favorite.serialNumber) {
          drug.isBookmarked = true;
          break;
        }
      }
    }
    setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreDrugs();
    }
  }

  void _loadMoreDrugs() async {
    if (_isLoading || drugs.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // 리스트에서 마지막 알약의 ID 가져오기
    final lastDrugId = drugs.last.pillId;

    // 더 많은 데이터를 로드하기 위해 searchTextAndShape 함수 호출
    await searchService.searchTextAndShape(
      context,
      _controller.text,
      selectedShapeItem?.text,
      selectedDivideLineItem?.text,
      selectedColorItem?.text,
      selectedFormulationItem?.text,
      null, // line 매개변수는 현재 선택된 값이 없으므로 null로 설정
      lastDrugId, // 마지막 알약의 ID 전달
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleBookmark(int index) {
    setState(() {
      drugs[index].isBookmarked = !drugs[index].isBookmarked;
      if (drugs[index].isBookmarked == true) {
        favoriteService.favoritePost(
            context, drugs[index].serialNumber, drugs[index].imgUrl);
      } else {
        favoriteService.favoriteDelete(context, drugs[index].serialNumber);
      }
    });
  }

  void navigateToPillDetail(BuildContext context, int serialNumber, String imgUrl, String pillName, String pillDescription) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultPillDetail(
          serialNumber: serialNumber,
          imgUrl: imgUrl,
          pillName: pillName,
          pillDescription: pillDescription,
        ),
      ),
    );
  }

  void _searchTerm(String term) async {
    if (term.isNotEmpty) {
      showLoading(context, delayed: true); // Show loading spinner with delay

      await searchService.searchTextAndShape(
          context, term, null, null, null, null, null, null);

      hideLoading(context); // Hide loading spinner

      setState(() {
        drugs = DrugsManager().drugs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.wh,
        title: Text(
          '검색 결과',
          style: AppTextStyles.body1S16,
        ),
        leading: IconButton(
          icon: Image.asset(
            'assets/IconHeaderLeft.png',
            width: 20,
            height: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: 336,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 335,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.gr150,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/ion_search.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "알약 이름을 검색해보세요",
                      ),
                      onSubmitted: _searchTerm,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.h16,
            // 필터 버튼들 (모양, 분할선, 색상, 제형) 생략
            Gaps.h16,
            Text(
              '검색 결과 ${drugs.length}건',
              style: AppTextStyles.body5M14,
            ),
            Gaps.h12,
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: drugs.length + (_isLoading ? 1 : 0), // 로딩 중일 때 로딩 표시를 위한 추가 아이템
                itemBuilder: (context, index) {
                  if (index < drugs.length) {
                    final drug = drugs[index];
                    return GestureDetector(
                      onTap: () async {
                        await searchService.searchGet(context, drug.serialNumber);
                        navigateToPillDetail(
                            context,
                            drug.serialNumber,
                            drug.imgUrl,
                            drug.name,
                            "여기에 알약 설명을 추가하세요"
                        );
                      },
                      child: Container(
                        width: 336,
                        height: 96,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              drug.imgUrl,
                              width: 96,
                              height: 96,
                            ),
                            Gaps.w16,
                            Container(
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    drug.name,
                                    style: AppTextStyles.body1S16,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Gaps.h6,
                                  Text(
                                    '제품명 : ${drug.name}',
                                    style: AppTextStyles.body5M14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '제조회사 : ${drug.enterprise}',
                                    style: AppTextStyles.body5M14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '분류 : ${drug.classification}',
                                    style: AppTextStyles.body5M14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () => _toggleBookmark(index),
                                child: Image.asset(
                                  drug.isBookmarked
                                      ? 'assets/bookmarkclicked.png'
                                      : 'assets/bookmark.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                            Gaps.h16,
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                separatorBuilder: (context, index) => Gaps.h8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
