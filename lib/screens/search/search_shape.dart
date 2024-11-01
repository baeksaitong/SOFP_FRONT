import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/services/services_search.dart';
import '../../constans/colors.dart';
import '../../constans/text_styles.dart';
import '../../constans/gaps.dart';

final GlobalKey<_RgbButtonState> rgbButtonKey = GlobalKey<_RgbButtonState>();
final GlobalKey<_ShapeButtonState> shapeButtonKey = GlobalKey<_ShapeButtonState>();
final GlobalKey<_FormulationButtonState> formulationButtonKey = GlobalKey<_FormulationButtonState>();
final GlobalKey<_DivideLineButtonState> divideLineButtonKey = GlobalKey<_DivideLineButtonState>();
final GlobalKey<_KeywordFieldState> keywordKey = GlobalKey<_KeywordFieldState>();

class SearchShape extends StatefulWidget {
  const SearchShape({super.key});

  @override
  State<SearchShape> createState() => _SearchShapeState();
}

class _SearchShapeState extends State<SearchShape> {
  SearchService searchService = SearchService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '모양으로 찾기',
            style: AppTextStyles.body5M14,
          ),
          Gaps.h8,
          KeywordField(
            key: keywordKey,
          ),
          Gaps.h8,
          Row(
            children: [
              RgbButton(
                key: rgbButtonKey,
              ),
              Gaps.w8,
              ShapeButton(
                key: shapeButtonKey,
              ),
              Gaps.w8,
              FormulationButton(
                key: formulationButtonKey,
              ),
              Gaps.w8,
              DivideLineButton(
                key: divideLineButtonKey,
              ),
            ],
          ),
          Gaps.h14,
          Row(
            children: [
              OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            '다시 입력하시겠습니까?',
                            style: AppTextStyles.body2M16,
                            selectionColor: AppColors.gr800,
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                            '입력하신 내용이 전부 사라집니다',
                            style: AppTextStyles.body5M14,
                            selectionColor: AppColors.gr600,
                            textAlign: TextAlign.center,
                          ),
                          actions: <Widget>[
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
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
                                '취소',
                                style: AppTextStyles.body1S16,
                                selectionColor: AppColors.gr600,
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                rgbButtonKey.currentState?.resetSelection();
                                shapeButtonKey.currentState?.resetSelection();
                                formulationButtonKey.currentState
                                    ?.resetSelection();
                                divideLineButtonKey.currentState
                                    ?.resetSelection();
                                keywordKey.currentState?.resetSelection();

                                Navigator.of(context).pop();
                                // 초기화 로직을 추가하세요.
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
                                '초기화',
                                style: AppTextStyles.body1S16.copyWith(color: AppColors.gr600),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    minimumSize: Size(78, 48),
                    backgroundColor: AppColors.gr300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(
                    '초기화',
                    style: AppTextStyles.body3S15.copyWith(color: AppColors.gr600),
                  )),
              Gaps.w10,
              OutlinedButton(
                onPressed: () async {
                  // 여기에서 선택된 항목들의 상태를 로그로 출력
                  final color = rgbButtonKey.currentState?.finalText;
                  final shape = shapeButtonKey.currentState?.finalText;
                  final formulation = formulationButtonKey.currentState?.finalText;
                  final divideLine = divideLineButtonKey.currentState?.finalText;
                  final keyword = keywordKey.currentState?._keywordController.text;

                  for (var item in colorItems) {
                    item.isSelected = false; // 모든 colorItems의 isSelected를 false로 설정
                  }
                  for (var item in shapeItems) {
                    item.isSelected = false; // 모든 shapeItems isSelected를 false로 설정
                  }
                  for (var item in formulationItems) {
                    item.isSelected = false; // 모든 formulationItems isSelected를 false로 설정
                  }
                  for (var item in divideLineItems) {
                    item.isSelected = false; // 모든 divideLineItems isSelected를 false로 설정
                  }
                  showLoading(context, delayed: true); // Show loading spinner with delay

                  await searchService.searchTextAndShape(context, null, shape, keyword, color, formulation, divideLine, null);

                  hideLoading(context); // Hide loading spinner

                  navigateToSearchResult(keyword!);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide.none,
                  minimumSize: Size(228, 48),
                  maximumSize: Size(228, 48),
                  backgroundColor: AppColors.softTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                child: Image(
                    image: AssetImage('assets/icon_search_text_search.png')),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class KeywordField extends StatefulWidget {
  const KeywordField({super.key});

  @override
  State<KeywordField> createState() => _KeywordFieldState();
}

class _KeywordFieldState extends State<KeywordField> {
  final TextEditingController _keywordController = TextEditingController();

  void resetSelection() {
    setState(() {
      _keywordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.wh,
        borderRadius: BorderRadius.circular(16.0), // 둥근 모서리를 만들기
      ),
      child: Row(
        children: [
          Gaps.w16,
          Flexible(
            child: TextField(
              controller: _keywordController,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none, // No border when enabled
                focusedBorder: InputBorder.none, // No border when focused
                hintText: "알약 이름을 검색해보세요",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DivideLineButton extends StatefulWidget {
  const DivideLineButton({super.key});

  @override
  State<DivideLineButton> createState() => _DivideLineButtonState();
}

class _DivideLineButtonState extends State<DivideLineButton> {
  DivideLineItem? selectedDivideLineItem;
  String? finalImage;
  String? finalText;
  // 상태를 리셋하는 메서드
  void resetSelection() {
    setState(() {
      selectedDivideLineItem = null;
      finalImage = null;
      finalText = null;
      for (var item in divideLineItems) {
        item.isSelected = false; // 모든 divideLineItems의 isSelected를 false로 설정
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        padding: EdgeInsets.zero, // 패딩 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: AppColors.wh,
        minimumSize: Size(75.5, 75.5), // 버튼의 최소 크기 설정
      ),
      onPressed: () async {
        final DivideLineItem? selected =
        await showModalBottomSheet<DivideLineItem>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColors.gr150,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '모양 선택',
                    style: AppTextStyles.title3S18,
                  ),
                  Gaps.h16,
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: (76 / 68),
                      // 아이템 폭 대 높이 비율 조정

                      children: List.generate(divideLineItems.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedDivideLineItem != null) {
                                selectedDivideLineItem!.isSelected = false;
                              }
                              selectedDivideLineItem = divideLineItems[index];
                              selectedDivideLineItem!.isSelected = true;
                            }); // 색상 선택 로직 구현
                            Navigator.of(context).pop(selectedDivideLineItem);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.gr200,
                              border: divideLineItems[index].isSelected
                                  ? Border.all(
                                width: 2.0,
                                color: Colors.redAccent,
                              )
                                  : null,
                            ),
                            width: 76,
                            height: 68,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  divideLineItems[index].image,
                                  width: 36,
                                  height: 36,
                                ),
                                Gaps.h10,
                                Text(
                                  divideLineItems[index].text,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.body5M14
                                      .copyWith(color: AppColors.gr800),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Gaps.h32,
                ],
              ),
            );
          },
        );
        if (selected != null) {
          setState(() {
            finalText = selected.text;
            finalImage = selected.image;
          });
        }
      },
      child: Column(
        children: [
          Image.asset(
            finalImage ?? 'assets/mdi_pill-tablet.png',
            width: 32,
            height: 32,
          ),
          Gaps.h4,
          Text(
            finalText ?? '분할선',
            style: AppTextStyles.body5M14.copyWith(color: AppColors.bk),
          ),
        ],
      ),
    );
  }
}

class FormulationButton extends StatefulWidget {
  const FormulationButton({super.key});

  @override
  State<FormulationButton> createState() => _FormulationButtonState();
}

class _FormulationButtonState extends State<FormulationButton> {
  FormulationItem? selectedFormulationItem;
  String? finalImage;
  String? finalText;
  // 상태를 리셋하는 메서드
  void resetSelection() {
    setState(() {
      selectedFormulationItem = null;
      finalImage = null;
      finalText = null;
      for (var item in formulationItems) {
        item.isSelected = false; // 모든 formulationItems의 isSelected를 false로 설정
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        padding: EdgeInsets.zero, // 패딩 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: AppColors.wh,
        minimumSize: Size(75.5, 75.5), // 버튼의 최소 크기 설정
      ),
      onPressed: () async {
        final FormulationItem? selected =
        await showModalBottomSheet<FormulationItem>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColors.gr150,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '모양 선택',
                    style: AppTextStyles.title3S18,
                  ),
                  Gaps.h16,
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: (76 / 68),
                      // 아이템 폭 대 높이 비율 조정

                      children: List.generate(formulationItems.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedFormulationItem != null) {
                                selectedFormulationItem!.isSelected = false;
                              }
                              selectedFormulationItem = formulationItems[index];
                              selectedFormulationItem!.isSelected = true;
                            }); // 색상 선택 로직 구현
                            Navigator.of(context).pop(selectedFormulationItem);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.gr200,
                              border: formulationItems[index].isSelected
                                  ? Border.all(
                                width: 2.0,
                                color: Colors.redAccent,
                              )
                                  : null,
                            ),
                            width: 76,
                            height: 68,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  formulationItems[index].image,
                                  width: 36,
                                  height: 36,
                                ),
                                Gaps.h10,
                                Text(
                                  formulationItems[index].text,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.body5M14
                                      .copyWith(color: AppColors.gr800),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Gaps.h32,
                ],
              ),
            );
          },
        );
        if (selected != null) {
          setState(() {
            finalText = selected.text;
            finalImage = selected.image;
          });
        }
      },
      child: Column(
        children: [
          Image.asset(
            finalImage ?? 'assets/fluent_pill-16-filled.png',
            width: 32,
            height: 32,
          ),
          Gaps.h4,
          Text(
            finalText ?? '제형',
            style: AppTextStyles.body5M14.copyWith(color: AppColors.bk),
          ),
        ],
      ),
    );
  }
}

class ShapeButton extends StatefulWidget {
  const ShapeButton({super.key});

  @override
  State<ShapeButton> createState() => _ShapeButtonState();
}

class _ShapeButtonState extends State<ShapeButton> {
  ShapeItem? selectedShapeItem;
  String? finalImage;
  String? finalText;
  // 상태를 리셋하는 메서드
  void resetSelection() {
    setState(() {
      selectedShapeItem = null;
      finalImage = null;
      finalText = null;
      for (var item in shapeItems) {
        item.isSelected = false; // 모든 shapeItems의 isSelected를 false로 설정
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        padding: EdgeInsets.zero, // 패딩 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: AppColors.wh,
        minimumSize: Size(75.5, 75.5), // 버튼의 최소 크기 설정
      ),
      onPressed: () async {
        final ShapeItem? selected = await showModalBottomSheet<ShapeItem>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 400,
              padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColors.gr150,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '모양 선택',
                    style: AppTextStyles.title3S18,
                  ),
                  Gaps.h16,
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: (76 / 68),
                      // 아이템 폭 대 높이 비율 조정

                      children: List.generate(shapeItems.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedShapeItem != null) {
                                selectedShapeItem!.isSelected = false;
                              }
                              selectedShapeItem = shapeItems[index];
                              selectedShapeItem!.isSelected = true;
                            }); // 색상 선택 로직 구현
                            Navigator.of(context).pop(selectedShapeItem);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.gr200,
                              border: shapeItems[index].isSelected
                                  ? Border.all(
                                width: 2.0,
                                color: Colors.redAccent,
                              )
                                  : null,
                            ),
                            width: 76,
                            height: 68,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  shapeItems[index].image,
                                  width: 36,
                                  height: 36,
                                ),
                                Gaps.h10,
                                Text(
                                  shapeItems[index].text,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.body5M14
                                      .copyWith(color: AppColors.gr800),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Gaps.h32,
                ],
              ),
            );
          },
        );
        if (selected != null) {
          setState(() {
            finalText = selected.text;
            finalImage = selected.image;
          });
        }
      },
      child: Column(
        children: [
          Image.asset(
            finalImage ?? 'assets/mdi_shape-plus.png',
            width: 32,
            height: 32,
          ),
          Gaps.h4,
          Text(
            finalText ?? '모양',
            style: AppTextStyles.body5M14.copyWith(color: AppColors.bk),
          ),
        ],
      ),
    );
  }
}

class RgbButton extends StatefulWidget {
  const RgbButton({super.key});

  @override
  State<RgbButton> createState() => _RgbButtonState();
}

class _RgbButtonState extends State<RgbButton> {
  ColorItem? selectedColorItem;
  Color? finalColor;
  String? finalText;

  void resetSelection() {
    setState(() {
      selectedColorItem = null;
      finalColor = null;
      finalText = null;
      for (var item in colorItems) {
        item.isSelected = false; // 모든 colorItems의 isSelected를 false로 설정
      }
    });
  }

  Widget customRgbCircle() {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        color: finalColor,
        borderRadius: BorderRadius.all(Radius.circular(45)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        padding: EdgeInsets.zero, // 패딩 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: AppColors.wh,
        minimumSize: Size(75.5, 75.5), // 버튼의 최소 크기 설정
      ),
      onPressed: () async {
        final ColorItem? selected = await showModalBottomSheet<ColorItem>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColors.gr150,
              ),
              padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '색상 선택',
                    style: AppTextStyles.title3S18,
                  ),
                  Gaps.h16,
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 8,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 10,
                      childAspectRatio: (36 / 62), // 아이템 폭 대 높이 비율 조정

                      children: List.generate(colorItems.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedColorItem != null) {
                                selectedColorItem!.isSelected = false;
                              }
                              selectedColorItem = colorItems[index];
                              selectedColorItem!.isSelected = true;
                            }); // 색상 선택 로직 구현
                            Navigator.of(context).pop(selectedColorItem);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 22,
                                width: 22,
                                decoration: BoxDecoration(
                                  color: colorItems[index].color,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                                  border: colorItems[index].isSelected
                                      ? Border.all(
                                    width: 2.0,
                                    color: Colors.redAccent,
                                  )
                                      : null,
                                ),
                              ),
                              Gaps.h10,
                              Text(
                                colorItems[index].text,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body5M14
                                    .copyWith(color: AppColors.gr800),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  Gaps.h32,
                ],
              ),
            );
          },
        );
        if (selected != null) {
          setState(() {
            finalColor = selected.color; // 선택된 색상 적용
            finalText = selected.text; // 선택된 텍스트 적용
            for (var item in shapeItems) {
              item.isSelected = false; // 모든 shapeItems의 isSelected를 false로 설정
            }
          });
        }
      },
      child: Column(
        children: [
          finalColor != null
              ? customRgbCircle()
              : Image.asset(
            'assets/solar_pallete-2-bold-duotone.png',
            width: 32,
            height: 32,
          ),
          Gaps.h4,
          Text(
            finalText ?? '색상',
            style: AppTextStyles.body5M14.copyWith(color: AppColors.bk),
          ),
        ],
      ),
    );
  }
}

Color? getColorFromText(String colorText) {
  final colorItem = colorItems.firstWhere(
        (item) => item.text == colorText,
    orElse: () => ColorItem(color: Colors.transparent, text: 'Unknown'),
  );
  return colorItem.color;
}

class ColorItem {
  final Color color;
  final String text;
  bool isSelected;

  ColorItem({required this.color, required this.text, this.isSelected = false});
}

class ShapeItem {
  final String text;
  final String image;
  bool isSelected;

  ShapeItem({required this.text, required this.image, this.isSelected = false});
}

class FormulationItem {
  final String text;
  final String image;
  bool isSelected;

  FormulationItem(
      {required this.text, required this.image, this.isSelected = false});
}

class DivideLineItem {
  final String text;
  final String image;
  bool isSelected;

  DivideLineItem(
      {required this.text, required this.image, this.isSelected = false});
}

final List<ColorItem> colorItems = [
  ColorItem(color: Colors.white, text: '하양'),
  ColorItem(color: Colors.yellow, text: '노랑'),
  ColorItem(color: Colors.orange, text: '주황'),
  ColorItem(color: Colors.pink, text: '분홍'),
  ColorItem(color: Colors.red, text: '빨강'),
  ColorItem(color: Colors.brown, text: '갈색'),
  ColorItem(color: Colors.lightGreen, text: '연두'),
  ColorItem(color: Colors.green, text: '초록'),
  ColorItem(color: Colors.blueGrey, text: '청록'),
  ColorItem(color: Colors.blue, text: '파랑'),
  ColorItem(color: Colors.indigo, text: '남색'),
  ColorItem(color: Colors.deepPurple, text: '자주'),
  ColorItem(color: Colors.purple, text: '보라'),
  ColorItem(color: Colors.grey, text: '회색'),
  ColorItem(color: Colors.black, text: '검정'),
  ColorItem(color: Color(0x00d9d9d9), text: '투명'),
];

final List<ShapeItem> shapeItems = [
  ShapeItem(text: '원형', image: 'assets/shapes/circle.png'),
  ShapeItem(text: '타원형', image: 'assets/shapes/ellipse.png'),
  ShapeItem(text: '장방형', image: 'assets/shapes/rectangle.png'),
  ShapeItem(text: '반원형', image: 'assets/shapes/semicircle.png'),
  ShapeItem(text: '삼각형', image: 'assets/shapes/triangle.png'),
  ShapeItem(text: '사각형', image: 'assets/shapes/square.png'),
  ShapeItem(text: '마름모형', image: 'assets/shapes/rhombus.png'),
  ShapeItem(text: '오각형', image: 'assets/shapes/pentagon.png'),
  ShapeItem(text: '육각형', image: 'assets/shapes/hexagon.png'),
  ShapeItem(text: '팔각형', image: 'assets/shapes/octagon.png'),
  ShapeItem(text: '기타', image: 'assets/shapes/shapes.png'),
];

final List<FormulationItem> formulationItems = [
  FormulationItem(text: '정제', image: 'assets/formulations/refine.png'),
  FormulationItem(text: '경질캡슐', image: 'assets/formulations/reshuffle.png'),
  FormulationItem(text: '연질캡슐', image: 'assets/formulations/soft.png'),
  FormulationItem(text: '기타', image: 'assets/formulations/others.png'),
];

final List<DivideLineItem> divideLineItems = [
  DivideLineItem(text: '원형', image: 'assets/divideLines/circle.png'),
  DivideLineItem(text: '(-)형', image: 'assets/divideLines/minus.png'),
  DivideLineItem(text: '(+)형', image: 'assets/divideLines/add-circular.png'),
  DivideLineItem(text: '기타', image: 'assets/divideLines/others.png'),
];

class ShapeSearchPage extends StatelessWidget {
  const ShapeSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // 그림자를 없애서 색 변화 방지
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SearchShape(),
            ],
          ),
          loadingOverlay(context), // Add the loading overlay here
        ],
      ),
    );
  }
}