import 'package:flutter/material.dart';

void popCurrentScreen(BuildContext context) {
  Navigator.pop(context);
}

class MyPagePage extends StatelessWidget {
  const MyPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: IconButton(
          onPressed: () => popCurrentScreen(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final String str = '이한조';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '$str 님\n안녕하세요!',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.greenAccent, width: 1),
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/free-icon-user-icon-4360835.png', width: 70, height: 70),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 30),
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
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20), // 상단 간격만 유지하고, 좌우 패딩 제거
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFF53DACA), width: 1),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 185, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내 알레르기 및 질병',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 80), // 상자 아래로 늘리기
                    ElevatedButton(
                      onPressed: () {
                        // 수정 버튼 클릭 시 동작
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('수정', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20), // 상단 간격만 유지 하고, 좌우 패딩 제거
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFF53DACA), width: 1),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 205, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내가 복용 중인 약',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 80), // 상자 아래로 늘리기
                    ElevatedButton(
                      onPressed: () {
                        // 수정 버튼 클릭 시 동작
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('수정', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}