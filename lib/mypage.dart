import 'package:flutter/material.dart';
import 'package:sofp_front/gaps.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: null,
        body: Stack(
          children: [
            Positioned(
              top:90,
              left:50,
              child: Text(
                '사통백이님\n안녕하세요!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
              ),
            ),
            Positioned(
              top: 170,
              left: 60,
              child: ElevatedButton(
                onPressed: () {
                  // 정보 수정 버튼 클릭 시 동작할 내용
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: Text('정보 수정'),
              ),
            ),
            Positioned(
              top: 90,
              left: 270,
              child: InkWell(
                onTap: () {

                },
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.greenAccent, width: 1),
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('free-icon-user-icon-4360835.png'),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 240,
              left: 35,
                child: Container(
                  width: 330,
                  height: 215,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 330,
                          height: 215,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFF53DACA)),
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 15,
                        child: SizedBox(
                          width: 200.21,
                          height: 33.04,
                          child: Text(
                            '내 알레르기 & 질병',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 270,
                        top: 15,
                        child: SizedBox(
                          width: 30,
                          height: 20,
                          child: ElevatedButton(
                            onPressed: () {
                              // 정보 수정 버튼 클릭 시 동작할 내용
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                            ),
                            child: Text('수정'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
            Positioned(
              top: 490,
              left: 35,
              child: Container(
                width: 330,
                height: 215,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 330,
                        height: 215,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Color(0xFF53DACA)),
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 15,
                      child: SizedBox(
                        width: 200.21,
                        height: 33.04,
                        child: Text(
                          '내가 복용 중인 약',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 270,
                      top: 15,
                      child: SizedBox(
                        width: 30,
                        height: 20,
                        child: ElevatedButton(
                          onPressed: () {
                            // 정보 수정 버튼 클릭 시 동작할 내용
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text('수정'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
