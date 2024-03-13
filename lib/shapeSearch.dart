import 'package:flutter/material.dart';
import 'gaps.dart';

class ShapeSearchColor extends StatelessWidget {
  const ShapeSearchColor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('모양으로 찾기'),
        ),
        body: Column(
          children: const [
            Row(
              children: [
                ShapeSearchRgbButton(),
                Gaps.w4,
                ShapeSearchShape(),
              ],
            ),
            Gaps.h4,
            Row(
              children: [
                ShapeSearchFormulation(),
                Gaps.w4,
                ShapeSearchDivideLine(),
              ],
            ),
          ],
        ),
      ),
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

