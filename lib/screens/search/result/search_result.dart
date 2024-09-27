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
import 'package:flutter/widgets.dart';
import 'package:sopf_front/home.dart';
import 'package:sopf_front/main.dart';

// Project imports:
import 'package:sopf_front/managers/managers_api_client.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/screens/search/result/search_result_pill_detail.dart';
import 'package:sopf_front/screens/search/search_shape.dart';
import 'package:sopf_front/services/services_favorite.dart';
import 'package:sopf_front/services/services_search.dart';
import 'package:sopf_front/screens/search/search_shape.dart';

import '../../../navigates.dart';

class SearchResult extends StatefulWidget {
  final String searchKeyword;

  const SearchResult({super.key, required this.searchKeyword});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // 선택된 필터 옵션들
  ColorItem? selectedColorItem;
  ShapeItem? selectedShapeItem;
  FormulationItem? selectedFormulationItem;
  DivideLineItem? selectedDivideLineItem;

  // 필터 버튼의 초기 텍스트
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

    // 검색어 설정
    _controller.text = widget.searchKeyword;
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

    // 북마크 설정
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

    final lastDrugId = drugs.last.pillId;

    // 검색 API 호출 (추가 데이터 로드)
    await searchService.searchTextAndShape(
      context,
      _controller.text,
      selectedShapeItem?.text,
      selectedDivideLineItem?.text,
      selectedColorItem?.text,
      selectedFormulationItem?.text,
      null, // 기타 필터
      lastDrugId, // 마지막 알약 ID
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleBookmark(int index) {
    setState(() {
      drugs[index].isBookmarked = !drugs[index].isBookmarked;
      if (drugs[index].isBookmarked == true) {
        favoriteService.favoritePost(context, drugs[index].serialNumber, drugs[index].imgUrl);
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
      showLoading(context, delayed: true); // 로딩 표시

      await searchService.searchTextAndShape(
        context,
        term,
        selectedShapeItem?.text,
        selectedDivideLineItem?.text,
        selectedColorItem?.text,
        selectedFormulationItem?.text,
        null,
        null,
      );

      hideLoading(context); // 로딩 숨기기

      setState(() {
        drugs = DrugsManager().drugs;
      });
    }
  }

  void updateButtonText() {
    setState(() {
      shapeText = selectedShapeItem?.text ?? '모양';
      divideLineText = selectedDivideLineItem?.text ?? '분할선';
      colorText = selectedColorItem?.text ?? '색상';
      formulationText = selectedFormulationItem?.text ?? '제형';
    });
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
            navigateToHome();
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
                    onPressed: () {
                      // TextField에서 입력된 검색어를 가져와서 _searchTerm 함수 호출
                      _searchTerm(_controller.text);
                    },
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
            // 필터 버튼들 (모양, 분할선, 색상, 제형)
            //...
            Row(
              children: [
                Container(
                  width: 42,
                  height: 38,
                  child: OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true, // 스크롤 가능한 모달을 허용
                        builder: (BuildContext context) {
                          double height = MediaQuery.of(context).size.height *
                              0.8; // 화면 높이의 50%로 설정
                          return StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setStateModal) {
                                return Container(
                                  height: height,
                                  padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                    color: AppColors.gr150,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                shapeText,
                                                style: AppTextStyles.title3S18,
                                              ),
                                              Gaps.h16,
                                              Container(
                                                height: 260,
                                                child: GridView.count(
                                                  crossAxisCount: 4,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio: (76 / 68),
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  children: List.generate(
                                                      shapeItems.length, (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setStateModal(() {
                                                          if (selectedShapeItem !=
                                                              null) {
                                                            selectedShapeItem!
                                                                .isSelected = false;
                                                          }
                                                          selectedShapeItem =
                                                          shapeItems[index];
                                                          selectedShapeItem!
                                                              .isSelected =
                                                          true;
                                                          shapeText =
                                                              shapeItems[index]
                                                                  .text;
                                                        });
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: AppColors.gr200,
                                                          border: shapeItems[index]
                                                              .isSelected
                                                              ? Border.all(
                                                            width: 2.0,
                                                            color: Colors
                                                                .redAccent,
                                                          )
                                                              : null,
                                                        ),
                                                        width: 76,
                                                        height: 68,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Image.asset(
                                                              shapeItems[index]
                                                                  .image,
                                                              width: 36,
                                                              height: 36,
                                                            ),
                                                            Gaps.h10,
                                                            Text(
                                                              shapeItems[index]
                                                                  .text,
                                                              textAlign:
                                                              TextAlign.center,
                                                              style: AppTextStyles
                                                                  .body5M14
                                                                  .copyWith(
                                                                  color: AppColors
                                                                      .gr800),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                              Gaps.h14,
                                              Text(
                                                divideLineText,
                                                style: AppTextStyles.title3S18,
                                              ),
                                              Gaps.h16,
                                              Container(
                                                height: 110,
                                                child: GridView.count(
                                                  crossAxisCount: 4,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio: (76 / 68),
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  children: List.generate(
                                                      divideLineItems.length,
                                                          (index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            setStateModal(() {
                                                              if (selectedDivideLineItem !=
                                                                  null) {
                                                                selectedDivideLineItem!
                                                                    .isSelected =
                                                                false;
                                                              }
                                                              selectedDivideLineItem =
                                                              divideLineItems[
                                                              index];
                                                              selectedDivideLineItem!
                                                                  .isSelected =
                                                              true;
                                                              divideLineText =
                                                                  divideLineItems[index]
                                                                      .text;
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: AppColors.gr200,
                                                              border:
                                                              divideLineItems[index]
                                                                  .isSelected
                                                                  ? Border.all(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .redAccent,
                                                              )
                                                                  : null,
                                                            ),
                                                            width: 76,
                                                            height: 68,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Image.asset(
                                                                  divideLineItems[index]
                                                                      .image,
                                                                  width: 36,
                                                                  height: 36,
                                                                ),
                                                                Gaps.h10,
                                                                Text(
                                                                  divideLineItems[index]
                                                                      .text,
                                                                  textAlign:
                                                                  TextAlign.center,
                                                                  style: AppTextStyles
                                                                      .body5M14
                                                                      .copyWith(
                                                                      color: AppColors
                                                                          .gr800),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ),
                                              Text(
                                                colorText,
                                                style: AppTextStyles.title3S18,
                                              ),
                                              Gaps.h16,
                                              Container(
                                                height: 180, // 전체 화면 높이
                                                child: GridView.count(
                                                  crossAxisCount: 8,
                                                  crossAxisSpacing: 6,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio: (36 / 62),
                                                  // 아이템 폭 대 높이 비율 조정
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  children: List.generate(
                                                      colorItems.length, (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setStateModal(() {
                                                          if (selectedColorItem !=
                                                              null) {
                                                            selectedColorItem!
                                                                .isSelected = false;
                                                          }
                                                          selectedColorItem =
                                                          colorItems[index];
                                                          selectedColorItem!
                                                              .isSelected =
                                                          true;
                                                          colorText =
                                                              colorItems[index]
                                                                  .text;
                                                        });
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Container(
                                                            height: 22,
                                                            width: 22,
                                                            decoration:
                                                            BoxDecoration(
                                                              color:
                                                              colorItems[index]
                                                                  .color,
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                      45)),
                                                              border: colorItems[
                                                              index]
                                                                  .isSelected
                                                                  ? Border.all(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .redAccent,
                                                              )
                                                                  : null,
                                                            ),
                                                          ),
                                                          Gaps.h10,
                                                          Text(
                                                            colorItems[index].text,
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: AppTextStyles
                                                                .body5M14
                                                                .copyWith(
                                                                color: AppColors
                                                                    .gr800),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                              Text(
                                                formulationText,
                                                style: AppTextStyles.title3S18,
                                              ),
                                              Gaps.h16,
                                              Container(
                                                height: 110,
                                                child: GridView.count(
                                                  crossAxisCount: 4,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio: (76 / 68),
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  // 스크롤 내부에서만 작동

                                                  children: List.generate(
                                                      formulationItems.length,
                                                          (index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            setStateModal(() {
                                                              if (selectedFormulationItem !=
                                                                  null) {
                                                                selectedFormulationItem!
                                                                    .isSelected =
                                                                false;
                                                              }
                                                              selectedFormulationItem =
                                                              formulationItems[
                                                              index];
                                                              selectedFormulationItem!
                                                                  .isSelected =
                                                              true;
                                                              formulationText =
                                                                  formulationItems[index]
                                                                      .text;
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: AppColors.gr200,
                                                              border:
                                                              formulationItems[index]
                                                                  .isSelected
                                                                  ? Border.all(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .redAccent,
                                                              )
                                                                  : null,
                                                            ),
                                                            width: 76,
                                                            height: 68,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Image.asset(
                                                                  formulationItems[index]
                                                                      .image,
                                                                  width: 36,
                                                                  height: 36,
                                                                ),
                                                                Gaps.h10,
                                                                Text(
                                                                  formulationItems[index]
                                                                      .text,
                                                                  textAlign:
                                                                  TextAlign.center,
                                                                  style: AppTextStyles
                                                                      .body5M14
                                                                      .copyWith(
                                                                      color: AppColors
                                                                          .gr800),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 335,
                                        height: 52,
                                        margin: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                          color: AppColors.softTeal,
                                        ),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            debugPrint(selectedShapeItem?.text);
                                            debugPrint(
                                                selectedDivideLineItem?.text);
                                            debugPrint(selectedColorItem?.text);
                                            debugPrint(
                                                selectedFormulationItem?.text);
                                            debugPrint(shapeText);
                                            debugPrint(divideLineText);
                                            debugPrint(colorText);
                                            debugPrint(formulationText);

                                            Navigator.of(context).pop();
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide.none,
                                          ),
                                          child: Text(
                                            '검색하기',
                                            style: AppTextStyles.body1S16.copyWith(
                                                color: AppColors.deepTeal),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ).then((_) {
                        updateButtonText();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.gr300,
                        width: 1.0,
                      ),
                      padding: EdgeInsets.zero, // 내부 패딩을 제거하여 공간 확보
                    ),
                    child: Image.asset(
                      'assets/filter.png',
                      width: 18,
                      height: 18,
                    ),
                  ),
                ),
                Gaps.w8,
                Container(
                  width: 53,
                  height: 38,
                  child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.gr300,
                          width: 1.0,
                        ),
                        padding: EdgeInsets.zero, // 내부 패딩을 제거하여 공간 확보
                      ),
                      child: Text(
                        shapeText,
                        style: AppTextStyles.body5M14
                            .copyWith(color: AppColors.gr700),
                      )),
                ),
                Gaps.w8,
                Container(
                  width: 65,
                  height: 38,
                  child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.gr300,
                          width: 1.0,
                        ),
                        padding: EdgeInsets.zero, // 내부 패딩을 제거하여 공간 확보
                      ),
                      child: Text(
                        divideLineText,
                        style: AppTextStyles.body5M14
                            .copyWith(color: AppColors.gr700),
                      )),
                ),
                Gaps.w8,
                Container(
                  width: 53,
                  height: 38,
                  child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.gr300,
                          width: 1.0,
                        ),
                        padding: EdgeInsets.zero, // 내부 패딩을 제거하여 공간 확보
                      ),
                      child: Text(
                        colorText,
                        style: AppTextStyles.body5M14
                            .copyWith(color: AppColors.gr700),
                      )),
                ),
                Gaps.w8,
                Container(
                  width: 53,
                  height: 38,
                  child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.gr300,
                          width: 1.0,
                        ),
                        padding: EdgeInsets.zero, // 내부 패딩을 제거하여 공간 확보
                      ),
                      child: Text(
                        formulationText,
                        style: AppTextStyles.body5M14
                            .copyWith(color: AppColors.gr700),
                      )),
                ),
              ],
            ),
            Gaps.h16,
            Text(
              '검색 결과 ${drugs.length}건',
              style: AppTextStyles.body5M14,
            ),
            Gaps.h12,
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: drugs.length + (_isLoading ? 1 : 0),
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
