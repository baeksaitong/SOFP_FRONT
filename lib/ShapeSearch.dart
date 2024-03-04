import 'package:flutter/material.dart';
import 'package:sofp_front/gaps.dart';

class ShapeSearchColor extends StatelessWidget {
  const ShapeSearchColor({super.key});

  @override
  Widget build(BuildContext context) {
    String buttonName;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('모양으로 찾기'),
        ),
/*        body: ShapeSearchColorClickWidget(),*/
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
/*
class ShapeSearchColorClickWidget extends StatelessWidget {
  const ShapeSearchColorClickWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 220,
      margin: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Color(0xff000000),
        ),
        borderRadius: BorderRadius.circular(24),
        // borderRadius: BorderRadius.circular(36)
      ),
      child: Column(
        children: [
          Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              spacing: 5,
              runSpacing: 5,
              children: [
                customColorButton('하양', Colors.white),
                customColorButton('노랑', Colors.yellow),
                customColorButton('주황', Colors.orange),
                customColorButton('분홍', Colors.pink),
                customColorButton('빨강', Colors.red),
                customColorButton('갈색', Colors.brown),
                customColorButton('연두', Colors.lightGreen),
                customColorButton('초록', Colors.green),
                customColorButton('청록', Colors.blueGrey),
                customColorButton('파랑', Colors.blue),
                customColorButton('남색', Colors.indigo),
                customColorButton('자주', Colors.deepPurple),
                customColorButton('보라', Colors.purple),
                customColorButton('회색', Colors.grey),
                customColorButton('검정', Colors.black),
                customColorButton('투명', Color(0x00d9d9d9)),
                customColorButton('전체', Colors.transparent),
              ]
          ),
          Gaps.h16,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customColorButton('취소', Colors.black12),
              Gaps.w72,
              customColorButton('확인', Colors.black12),
            ],
          ),
        ],
      ),
    );
  }
}
*/