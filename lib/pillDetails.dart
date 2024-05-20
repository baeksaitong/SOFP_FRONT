import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'First App',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: PillDetailsPage(),
  ));
}

//test

class PillDetailsPage extends StatelessWidget {
  const PillDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 8),
                Text(
                  '알약 이름', // 여기에 알약 이름이 들어갑니다
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 여기에 알약 이미지가 들어갑니다
            Container(
              height: 200, // 이미지 높이 설정
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              // 이미지를 표시하는 위젯을 넣어주세요
            ),
            SizedBox(height: 10),
            Text(
              '성분', // 여기에 알약 성분이 들어갑니다
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '성분 정보를 여기에 표시해주세요.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '주의사항', // 여기에 알약 주의사항이 들어갑니다
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '주의사항 정보를 여기에 표시해주세요.',
              style: TextStyle(fontSize: 16),
            ),
            // 추가적인 알약 정보를 표시하는 위젯을 넣어주세요
          ],
        ),
      ),
    );
  }
}
