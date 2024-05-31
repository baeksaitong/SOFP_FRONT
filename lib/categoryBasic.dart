import 'package:flutter/material.dart';
import 'appTextStyles.dart'; // 원하는 글꼴 스타일이 정의된 파일을 임포트
import 'appColors.dart'; // 색상 정의 파일을 임포트
import 'gaps.dart';

class MedicationPage extends StatelessWidget {
  const MedicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> medications = [
      {
        'name': '가스디알정50밀리그램',
        'manufacturer': '일동제약',
        'category': '기타소화기관용약 | 일반 의약품',
        'image': 'assets/exPill.png'
      },
      // 추가 항목을 여기에 추가
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('복용중인 알약', style: AppTextStyles.body1S16),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            'assets/IconHeaderLeft.png',
            width: 20,
            height: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: AppColors.wh,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset('assets/exPill.png', width: 48, height: 48),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Text(
                          '카테고리 - 카테고리 제목',
                          style: AppTextStyles.title1B24,
                        ),
                        SizedBox(width: 4.0),
                        Icon(Icons.circle, color: Colors.red, size: 10),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Gaps.h16,
            Expanded(
              child: ListView.builder(
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  final medication = medications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.asset(medication['image']!),
                      title: Text(medication['name']!,
                          style: AppTextStyles.body1S16),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('제품명: ${medication['name']}'),
                          Text('제조회사: ${medication['manufacturer']}'),
                          Text('분류: ${medication['category']}'),
                        ],
                      ),
                      trailing: Icon(Icons.star, color: AppColors.deepTeal),
                      isThreeLine: true,
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // 추가 버튼 동작
                  },
                  child: Text(
                    '추가',
                    style:
                        AppTextStyles.body3S15.copyWith(color: AppColors.gr800),
                  ),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    // 수정 버튼 동작
                  },
                  child: Text(
                    '수정',
                    style:
                        AppTextStyles.body3S15.copyWith(color: AppColors.gr800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MedicationPage(),
  ));
}
