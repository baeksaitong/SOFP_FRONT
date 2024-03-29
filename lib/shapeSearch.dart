import 'package:flutter/material.dart';
import 'gaps.dart';
import 'main.dart';

final GlobalKey<_ShapeSearchRgbButtonState> rgbButtonKey = GlobalKey<_ShapeSearchRgbButtonState>();
final GlobalKey<_ShapeSearchShapeState> shapeButtonKey = GlobalKey<_ShapeSearchShapeState>();
final GlobalKey<_ShapeSearchFormulationState> formulationButtonKey = GlobalKey<_ShapeSearchFormulationState>();
final GlobalKey<_ShapeSearchDivideLineState> divideLineButtonKey = GlobalKey<_ShapeSearchDivideLineState>();
final GlobalKey<_ShapeSearchKeywordState> keywordKey = GlobalKey<_ShapeSearchKeywordState>();

// class ShapeSearchColor extends StatelessWidget {
//   const ShapeSearchColor({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('모양으로 찾기'),
//       ),
//       body: Column(
//         children: [
//           ShapeSearchKeyword(key: keywordKey,),
//           Gaps.h4,
//           Row(
//             children: [
//               ShapeSearchRgbButton(key: rgbButtonKey), // GlobalKey 할당
//               Gaps.w4,
//               ShapeSearchShape(key: shapeButtonKey),
//             ],
//           ),
//           Gaps.h4,
//           Row(
//             children: [
//               ShapeSearchFormulation(key: formulationButtonKey),
//               Gaps.w4,
//               ShapeSearchDivideLine(key: divideLineButtonKey),
//             ],
//           ),
//           Gaps.h4,
//           Row(
//             children: [
//               SizedBox(
//                 width: 140,
//                 height: 45,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // 각 GlobalKey를 사용하여 위젯의 상태에 접근하고 resetSelection 메서드를 호출
//                     rgbButtonKey.currentState?.resetSelection();
//                     shapeButtonKey.currentState?.resetSelection();
//                     formulationButtonKey.currentState?.resetSelection();
//                     divideLineButtonKey.currentState?.resetSelection();
//                     keywordKey.currentState?.resetSelection();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF53DACA),
//                     side: BorderSide(
//                       width: 1,
//                       color: Color(0xFF53DACA),
//                     ),
//                     padding: EdgeInsets.all(8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       SizedBox(width: 16),
//                       Text("다시 입력"),
//                       Gaps.w8,
//                       Image.asset(
//                         'assets/refresh.png',
//                         width: 30,
//                         height: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Gaps.w4,
//               SizedBox(
//                 width: 140,
//                 height: 45,
//                 child: OutlinedButton(
//                     onPressed: () {
//                       // 여기에서 선택된 항목들의 상태를 로그로 출력하는 부분은 유지
//                       final color = rgbButtonKey.currentState?.finalText ?? "색상 없음";
//                       final shape = shapeButtonKey.currentState?.finalText ?? "모양 없음";
//                       final formulation = formulationButtonKey.currentState?.finalText ?? "제형 없음";
//                       final divideLine = divideLineButtonKey.currentState?.finalText ?? "분할선 없음";
//                       final keyword = keywordKey.currentState?._controller.text ?? "키워드 없음";
//
//                       debugPrint('입력한 키워드: $keyword');
//                       debugPrint('선택된 색상: $color');
//                       debugPrint('선택된 모양: $shape');
//                       debugPrint('선택된 제형: $formulation');
//                       debugPrint('선택된 분할선: $divideLine');
//
//                       // 페이지 전환을 위한 navigateToSearchResult 함수 호출
//                       navigateToSearchResult(context); // context 전달이 중요합니다.
//                     },
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(
//                       width: 1,
//                       color: Color(0xFF53DACA),
//                     ),
//                     padding: EdgeInsets.all(8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                     ),
//                   ),
//
//                   child: Row(
//                     children: const [
//                       Gaps.w16,
//                       Icon(
//                           Icons.search,
//                         size: 30,
//                       ),
//                       Gaps.w20,
//                       Text("검색"),
//                     ],
//                   )
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class ShapeSearhSelect extends StatefulWidget {
  const ShapeSearhSelect({super.key});

  @override
  State<ShapeSearhSelect> createState() => _ShapeSearhSelectState();
}

class _ShapeSearhSelectState extends State<ShapeSearhSelect> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShapeSearchKeyword(key: keywordKey,),
        Gaps.h4,
        Row(
          children: [
            ShapeSearchRgbButton(key: rgbButtonKey), // GlobalKey 할당
            Gaps.w4,
            ShapeSearchShape(key: shapeButtonKey),
          ],
        ),
        Gaps.h4,
        Row(
          children: [
            ShapeSearchFormulation(key: formulationButtonKey),
            Gaps.w4,
            ShapeSearchDivideLine(key: divideLineButtonKey),
          ],
        ),
        Gaps.h4,
        Row(
          children: [
            SizedBox(
              width: 140,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  // 각 GlobalKey를 사용하여 위젯의 상태에 접근하고 resetSelection 메서드를 호출
                  rgbButtonKey.currentState?.resetSelection();
                  shapeButtonKey.currentState?.resetSelection();
                  formulationButtonKey.currentState?.resetSelection();
                  divideLineButtonKey.currentState?.resetSelection();
                  keywordKey.currentState?.resetSelection();
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF53DACA),
                  side: BorderSide(
                    width: 1,
                    color: Color(0xFF53DACA),
                  ),
                  padding: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Text("다시 입력"),
                    Gaps.w8,
                    Image.asset(
                      'assets/refresh.png',
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            Gaps.w4,
            SizedBox(
              width: 140,
              height: 45,
              child: OutlinedButton(
                  onPressed: () {
                    // 여기에서 선택된 항목들의 상태를 로그로 출력
                    final color = rgbButtonKey.currentState?.finalText ?? "색상 없음";
                    final shape = shapeButtonKey.currentState?.finalText ?? "모양 없음";
                    final formulation = formulationButtonKey.currentState?.finalText ?? "제형 없음";
                    final divideLine = divideLineButtonKey.currentState?.finalText ?? "분할선 없음";
                    final keyword = keywordKey.currentState?._controller.text ?? "키워드 없음";

                    // 선택된 항목 로그로 출력
                    debugPrint('입력한 키워드: $keyword');
                    debugPrint('선택된 색상: $color');
                    debugPrint('선택된 모양: $shape');
                    debugPrint('선택된 제형: $formulation');
                    debugPrint('선택된 분할선: $divideLine');

                    for (var item in colorItems) {
                      item.isSelected = false; // 모든 colorItems의 isSelected를 false로 설정
                    }
                    for (var item in shapeItems) {
                      item.isSelected = false; // 모든 colorItems의 isSelected를 false로 설정
                    }
                    for (var item in formulationItems) {
                      item.isSelected = false; // 모든 colorItems의 isSelected를 false로 설정
                    }
                    for (var item in divideLineItems) {
                      item.isSelected = false; // 모든 colorItems의 isSelected를 false로 설정
                    }
                    navigateToSearchResult(context); // context 전달이 중요합니다.
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: 1,
                      color: Color(0xFF53DACA),
                    ),
                    padding: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Gaps.w16,
                      Icon(
                        Icons.search,
                        size: 30,
                      ),
                      Gaps.w20,
                      Text("검색"),
                    ],
                  )
              ),
            ),
          ],
        ),
      ],
    );
  }
}


Widget customColorButton(String colorName, Color color, VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: 50,
      height: 30,
      color: color,
      child: Center(
        child: Text(
          colorName,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.0,
          ),
        ),
      ),
    ),
  );
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
  ColorItem(color: Colors.transparent, text: '전체'),
];

final List<ShapeItem> shapeItems = [
  ShapeItem(text: '원형', image: 'assets/shapes/circle.png'),
  ShapeItem(text: '타원형', image: 'assets/shapes/ellipse-outline.png'),
  ShapeItem(text: '장방형', image: 'assets/shapes/rectangle.png'),
  ShapeItem(text: '반원형', image: 'assets/shapes/semicircle.png'),
  ShapeItem(text: '삼각형', image: 'assets/shapes/triangle-outline.png'),
  ShapeItem(text: '사각형', image: 'assets/shapes/square-outline.png'),
  ShapeItem(text: '마름모형', image: 'assets/shapes/rhombus.png'),
  ShapeItem(text: '오각형', image: 'assets/shapes/pentagon.png'),
  ShapeItem(text: '육각형', image: 'assets/shapes/hexagon.png'),
  ShapeItem(text: '팔각형', image: 'assets/shapes/octagon-outline.png'),
  ShapeItem(text: '기타', image: 'assets/shapes.png'),
  ShapeItem(text: '전체', image: 'assets/shapes.png'),
];

final List<FormulationItem> formulationItems = [
  FormulationItem(text: '정제', image: 'assets/formulations/refine.png'),
  FormulationItem(text: '경질캡슐', image: 'assets/formulations/reshuffle.png'),
  FormulationItem(text: '연질캡슐', image: 'assets/formulations/soft.png'),
  FormulationItem(text: '기타', image: 'assets/drugs.png'),
  FormulationItem(text: '전체', image: 'assets/drugs.png'),
];

final List<DivideLineItem> divideLineItems = [
  DivideLineItem(text: '원형', image: 'assets/divideLines/circle.png'),
  DivideLineItem(text: '( - )형', image: 'assets/divideLines/minus.png'),
  DivideLineItem(text: '( + )형', image: 'assets/divideLines/add-circular.png'),
];

class ShapeSearchRgbButton extends StatefulWidget {
  const ShapeSearchRgbButton({Key? key}) : super(key: key);

  @override
  State<ShapeSearchRgbButton> createState() => _ShapeSearchRgbButtonState();
}

class _ShapeSearchRgbButtonState extends State<ShapeSearchRgbButton> {
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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 45,
      child: OutlinedButton(
          onPressed: () async {
            // 사용자가 대화상자에서 선택한 ColorItem을 받아옵니다.
            final ColorItem? selected = await showDialog<ColorItem>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                ColorItem? localSelectedColorItem;

                return AlertDialog(
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 5,
                            runSpacing: 5,
                            children: colorItems.map((colorItem) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selectedColorItem != null) {
                                    selectedColorItem!.isSelected = false;
                                  }
                                  selectedColorItem = colorItem;
                                  selectedColorItem!.isSelected = true;
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: colorItem.color,
                                  border: colorItem.isSelected
                                      ? Border.all(
                                    width: 2.0,
                                    color: Colors.redAccent,
                                  )
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    colorItem.text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            )).toList(),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 취소 버튼 클릭 시 대화 상자 닫기
                                },
                                child: Text('취소'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(selectedColorItem); // 확인 버튼 클릭 시 선택한 색상 정보 반환
                                },
                                child: Text('확인'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            );

            // 대화상자로부터 반환된 ColorItem을 사용해 상태를 업데이트합니다.
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
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 1,
            color: finalColor ?? Color(0xFF53DACA),
          ),
          padding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Image.asset(
              'assets/rgb.png',
              width: 30,
              height: 30,
            ),
            SizedBox(width: 20),
            Text(finalText ?? "색상"),
          ],
        ),
      ),
    );
  }
}

class ShapeSearchShape extends StatefulWidget {
  const ShapeSearchShape({Key? key}) : super(key: key);

  @override
  State<ShapeSearchShape> createState() => _ShapeSearchShapeState();
}

class _ShapeSearchShapeState extends State<ShapeSearchShape> {
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
    return SizedBox(
      width: 140,
      height: 45,
      child: OutlinedButton(
        onPressed: () async {
          final ShapeItem? selected = await showDialog<ShapeItem>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              spacing: 5,
                              runSpacing: 5,
                              children:shapeItems.map((shapeItem) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if(selectedShapeItem != null) {
                                      selectedShapeItem!.isSelected=false;
                                    }
                                    selectedShapeItem = shapeItem;
                                    selectedShapeItem!.isSelected=true;
                                  });
                                },
                                child: Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: shapeItem.isSelected
                                        ? Border.all(
                                      width: 2.0,
                                      color: Colors.redAccent,
                                    )
                                        : null,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          shapeItem.image,
                                          width: 25,
                                          height: 25,
                                        ),
                                        Gaps.h10,
                                        Text(
                                          shapeItem.text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            height: 1.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )).toList(),
                            ),
                            Gaps.h16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 취소 버튼 클릭 시 대화 상자 닫기
                                  },
                                  child: Text('취소'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(selectedShapeItem); // 확인 버튼 클릭 시 선택한 색상 정보 반환
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            ),
                          ],
                        );
                      })
                );
              });
          if (selected != null) {
            setState(() {
              finalText=selected.text;
              finalImage=selected.image;
            });
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 1,
            color: Color(0xFF53DACA),
          ),
          padding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            ),
          ),
        ),
        child: Row(
          children: [
            Gaps.w16,
            Image.asset(
            finalImage ?? "assets/shapes.png",
              width: 30,
              height: 30,
            ),
            Gaps.w20,
            Text(finalText ?? '모양'),
          ],
        ),
      ),
    );
  }
}

class ShapeSearchFormulation extends StatefulWidget {
  const ShapeSearchFormulation({Key? key}) : super(key: key);

  @override
  State<ShapeSearchFormulation> createState() => _ShapeSearchFormulationState();
}

class _ShapeSearchFormulationState extends State<ShapeSearchFormulation> {
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
    return SizedBox(
      width: 140,
      height: 45,
      child: OutlinedButton(
        onPressed: () async {
          final FormulationItem? selected = await showDialog<FormulationItem>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              spacing: 5,
                              runSpacing: 5,
                              children: formulationItems.map((formulationItem) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedFormulationItem != null) {
                                      selectedFormulationItem!.isSelected = false;
                                    }
                                    selectedFormulationItem = formulationItem;
                                    selectedFormulationItem!.isSelected = true;
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: formulationItem.isSelected
                                        ? Border.all(
                                      width: 2.0,
                                      color: Colors.redAccent,
                                    )
                                        : null,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          formulationItem.image,
                                          width: 25,
                                          height: 25,
                                        ),
                                        SizedBox(height: 10), // Gaps.h10,
                                        Text(
                                          formulationItem.text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            height: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )).toList(),
                            ),
                            SizedBox(height: 16), // Gaps.h16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 취소 버튼 클릭 시 대화 상자 닫기
                                  },
                                  child: Text('취소'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(selectedFormulationItem); // 확인 버튼 클릭 시 선택한 정보 반환
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                );
              });
          if (selected != null) {
            setState(() {
              finalText = selected.text;
              finalImage = selected.image;
            });
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 1,
            color: Color(0xFF53DACA),
          ),
          padding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 16), // Gaps.w16,
            Image.asset(
              finalImage ?? "assets/drugs.png",
              width: 30,
              height: 30,
            ),
            SizedBox(width: 20), // Gaps.w20,
            Text(finalText ?? '형태'),
          ],
        ),
      ),
    );
  }
}

class ShapeSearchDivideLine extends StatefulWidget {
  const ShapeSearchDivideLine({Key? key}) : super(key: key);

  @override
  State<ShapeSearchDivideLine> createState() => _ShapeSearchDivideLineState();
}

class _ShapeSearchDivideLineState extends State<ShapeSearchDivideLine> {
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
    return SizedBox(
      width: 140,
      height: 45,
      child: OutlinedButton(
        onPressed: () async {
          final DivideLineItem? selected = await showDialog<DivideLineItem>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              spacing: 5,
                              runSpacing: 5,
                              children: divideLineItems.map((divideLineItem) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedDivideLineItem != null) {
                                      selectedDivideLineItem!.isSelected = false;
                                    }
                                    selectedDivideLineItem = divideLineItem;
                                    selectedDivideLineItem!.isSelected = true;
                                  });
                                },
                                child: Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: divideLineItem.isSelected
                                        ? Border.all(
                                      width: 2.0,
                                      color: Colors.redAccent,
                                    )
                                        : null,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          divideLineItem.image,
                                          width: 25,
                                          height: 25,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          divideLineItem.text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            height: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )).toList(),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('취소'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(selectedDivideLineItem);
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                );
              });
          if (selected != null) {
            setState(() {
              finalText = selected.text;
              finalImage = selected.image;
            });
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 1,
            color: Color(0xFF53DACA),
          ),
          padding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Image.asset(
              finalImage ?? "assets/pill.png", // Default image or make sure to replace with your default one
              width: 30,
              height: 30,
            ),
            SizedBox(width: 20),
            Text(finalText ?? '분할선'),
          ],
        ),
      ),
    );
  }
}

class ShapeSearchKeyword extends StatefulWidget {
  const ShapeSearchKeyword({super.key});

  @override
  State<ShapeSearchKeyword> createState() => _ShapeSearchKeywordState();
}

class _ShapeSearchKeywordState extends State<ShapeSearchKeyword> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // 사용하지 않을 때는 컨트롤러를 dispose 해야 합니다.
    _controller.dispose();
    super.dispose();
  }

  void resetSelection() {
    setState(() {
      _controller.clear();
    });
  }
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black,
        ),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          hintText: '검색 키워드를 입력하세요',
        ),
      ),
    );
  }
}