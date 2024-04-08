import 'package:flutter/material.dart';

void popCurrentScreen(BuildContext context) {
  Navigator.pop(context);
}

class MyPage_2 extends StatelessWidget {
  const MyPage_2({super.key});

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
                    child: Image.asset(
                        'assets/free-icon-user-icon-4360835.png', width: 70,
                        height: 70),
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
            padding: EdgeInsets.only(left: 20, top: 20),
            // 상단 간격만 유지하고, 좌우 패딩 제거
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
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 80), // 상자 아래로 늘리기
                    ElevatedButton(
                      onPressed: () {
                        print("수정 버튼 클릭됨"); // 버튼 클릭 이벤트 확인
                        _showEditDialog("내 알레르기 및 질병", "알레르기 및 질병을 입력해주세요", (newValue) {
                          setState(() {
                            // 상태를 업데이트하는 로직을 여기에 추가합니다.
                            // 예를 들어, 사용자가 입력한 새로운 값을 상태 변수에 저장합니다.
                            print("새로운 값: $newValue");
                          });
                        });
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
            padding: EdgeInsets.only(left: 20, top: 20),
            // 상단 간격만 유지 하고, 좌우 패딩 제거
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
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 80), // 상자 아래로 늘리기
                    ElevatedButton(
                      onPressed: () {
                        print("수정 버튼 클릭됨"); // 버튼 클릭 이벤트 확인
                        _showEditDialog("내가 복용 중인 약", "복용중인 약을 입력해주세요", (newValue) {
                          setState(() {
                            // 상태를 업데이트하는 로직을 여기에 추가합니다.
                            // 예를 들어, 사용자가 입력한 새로운 값을 상태 변수에 저장합니다.
                            print("새로운 값: $newValue");
                          });
                        });
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

  void _showEditDialog(String title, String currentValue,
      void Function(String) onSubmitted) {
    TextEditingController textEditingController = TextEditingController(
        text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 다이얼로그 모서리 둥글게
          ), // 이렇게 해서 다이얼로그 자체의 모양을 바꿀 수 있습니다.
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, // 다이얼로그 배경색
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                  color: Colors.greenAccent, width: 2), // 다이얼로그 테두리
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 컨텐츠 크기에 맞게 다이얼로그 크기 조절
              children: <Widget>[
                Text(
                  "수정: $title",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(hintText: "여기에 새로운 값을 입력하세요"),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('취소'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('저장'),
                      onPressed: () {
                        onSubmitted(textEditingController.text);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}