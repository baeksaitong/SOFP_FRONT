import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';

final GlobalKey<_RgbButtonState> rgbButtonKey = GlobalKey<_RgbButtonState>();

class ShapeSearch extends StatefulWidget {
  const ShapeSearch({super.key});

  @override
  State<ShapeSearch> createState() => _ShapeSearchState();
}

class _ShapeSearchState extends State<ShapeSearch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '약을 검색해 보세요',
          style: AppTextStyles.title3S18,
        ),
        Gaps.h16,
        Container(
          width: 335,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.wh,
            borderRadius: BorderRadius.circular(16.0), // 둥근 모서리를 만들기
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "알약 이름을 검색해보세요",
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
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
        Text(
          '모양으로 찾기',
          style: AppTextStyles.body5M14,
        ),
        Gaps.h8,
        Container(
          width: 335,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.wh,
            borderRadius: BorderRadius.circular(16.0), // 둥근 모서리를 만들기
          ),
          child: Row(
            children: const [
              Gaps.w16,
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "알약 이름을 검색해보세요",
                  ),
                ),
              ),
            ],
          ),
        ),
        Gaps.h8,
        Row(
          children: [
            RgbButton(key: rgbButtonKey,),
            Gaps.w8,
            ShapeButton(),
            Gaps.w8,
            FormulationButton(),
            Gaps.w8,
            divideLineButton(),
          ],
        ),
        Gaps.h14,
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: BorderSide.none,
            minimumSize: Size(335, 48),
            backgroundColor: AppColors.softTeal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          child: Image(image: AssetImage('assets/icon_search_text_search.png')),
        )
      ],
    );
  }
}
class divideLineButton extends StatefulWidget {
  const divideLineButton({super.key});

  @override
  State<divideLineButton> createState() => _divideLineButtonState();
}

class _divideLineButtonState extends State<divideLineButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        padding: EdgeInsets.zero,  // 패딩 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: AppColors.wh,
        minimumSize: Size(75.5, 75.5),  // 버튼의 최소 크기 설정
      ),
      onPressed: () {},
      child: Column(
        children: [
          Image.asset(
            'assets/mdi_pill-tablet.png',
            width: 32,
            height: 32,
          ),
          Gaps.h4,
          Text(
            '분할선',
            style: AppTextStyles.body5M14.copyWith(color: AppColors.bk),
          ),
        ],
      ),
    ),
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
        padding: EdgeInsets.zero,  // 패딩 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: AppColors.wh,
        minimumSize: Size(75.5, 75.5),  // 버튼의 최소 크기 설정
      ),
      onPressed: () async {
        final FormulationItem? selected = await showModalBottomSheet<FormulationItem>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
              color: AppColors.gr150,
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
                                  style: AppTextStyles.body5M14.copyWith(
                                      color: AppColors.gr800),
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
        padding: EdgeInsets.zero,  // 패딩 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: AppColors.wh,
        minimumSize: Size(75.5, 75.5),  // 버튼의 최소 크기 설정
      ),
      onPressed: () async {
        final ShapeItem? selected = await showModalBottomSheet<ShapeItem>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 400,
              padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
              color: AppColors.gr150,
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
                                  style: AppTextStyles.body5M14.copyWith(
                                      color: AppColors.gr800),
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
            finalText=selected.text;
            finalImage=selected.image;
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
  const RgbButton({Key? key}) : super(key: key);

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
        padding: EdgeInsets.zero,  // 패딩 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: AppColors.wh,
        minimumSize: Size(75.5, 75.5),  // 버튼의 최소 크기 설정
      ),
      onPressed: () async {
        final ColorItem? selected = await showModalBottomSheet<ColorItem>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              color: AppColors.gr150,
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
                            });// 색상 선택 로직 구현
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
                                  borderRadius: BorderRadius.all(Radius.circular(45)),
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
                                style: AppTextStyles.body5M14.copyWith(color: AppColors.gr800),
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
          finalColor != null ? customRgbCircle() : Image.asset(
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

  ShapeItem({required this.text, required this.image, this.isSelected=false});
}

class FormulationItem {
  final String text;
  final String image;
  bool isSelected;

  FormulationItem({required this.text, required this.image, this.isSelected=false});
}

class DivideLineItem {
  final String text;
  final String image;
  bool isSelected;

  DivideLineItem({required this.text, required this.image, this.isSelected=false});
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