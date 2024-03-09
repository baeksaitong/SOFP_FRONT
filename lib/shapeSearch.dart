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
        body: Row(
          children: const [
            ShapeSearchRgbButton(),
            ShapeSearchShape(),
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

class CustomColorButtonTest extends StatefulWidget {
  final ColorItem colorItem;
  final Function(ColorItem) onPressed;

  const CustomColorButtonTest({
    Key? key,
    required this.colorItem,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomColorButtonTestState createState() => _CustomColorButtonTestState();
}

class _CustomColorButtonTestState extends State<CustomColorButtonTest> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed(widget.colorItem);
      },
      child: Container(
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          color: widget.colorItem.color,
          border: widget.colorItem.isSelected
              ? Border.all(
            width: 2.0,
            color: Colors.redAccent,
          )
              : null,
        ),
        child: Center(
          child: Text(
            widget.colorItem.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
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
      width: 130,
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
  const ShapeSearchShape({super.key});

  @override
  State<ShapeSearchShape> createState() => _ShapeSearchShapeState();
}

class _ShapeSearchShapeState extends State<ShapeSearchShape> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 45,
      child: OutlinedButton(
        onPressed: () {},
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
            Image.asset('assets/shapes.png',width: 30, height: 30,),
            Gaps.w20,
            Text('모양'),
          ],
        ),
      ),
    );
  }
}
