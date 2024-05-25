import 'package:flutter/material.dart';
import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';

void main() {
  runApp(MaterialApp(
    title: 'First App',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: SearchResultPage(),
  ));
}

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  // 데이터 예시
  final List<Map<String, dynamic>> medications = [
    {
      'name': '가스디알정50밀리그람',
      'manufacturer': '일동제약',
      'category': '기타의소화기관용약 | 일반 의약품',
      'image': 'assets/expill.png',
      'isWarning': true,
    },
    {
      'name': '가스디알정50밀리그람',
      'manufacturer': '일동제약',
      'category': '기타의소화기관용약 | 일반 의약품',
      'image': 'assets/expill.png',
      'isWarning': false,
    },
    {
      'name': '가스디알정50밀리그람',
      'manufacturer': '일동제약',
      'category': '기타의소화기관용약 | 일반 의약품',
      'image': 'assets/expill.png',
      'isWarning': true,
    },
    {
      'name': '가스디알정50밀리그람',
      'manufacturer': '일동제약',
      'category': '기타의소화기관용약 | 일반 의약품',
      'image': 'assets/expill.png',
      'isWarning': false,
    },
  ];

  final List<bool> _favoriteStatus = [false, false, false, false];

  void _toggleFavorite(int index) {
    setState(() {
      _favoriteStatus[index] = !_favoriteStatus[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 결과', style: AppTextStyles.body1S16),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로 가기 동작 구현
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/expill.png', // 검색된 첫 번째 이미지 경로
                        width: 100,
                        height: 100,
                      ),
                      Gaps.w8,
                      Image.asset(
                        'assets/expill.png', // 검색된 두 번째 이미지 경로
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '촬영된 사진의 검색 결과',
                      style: AppTextStyles.body2M16,
                    ),
                    const Text('8건', style: AppTextStyles.body2M16),
                    ElevatedButton(
                      onPressed: () {
                        // 재촬영하기 버튼 동작 구현
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('재촬영하기',
                          style: AppTextStyles.body5M14
                              .copyWith(color: AppColors.deepTeal)),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Card(
                          child: ListTile(
                            leading: Image.asset(
                              medication['image'], // 약 이미지 경로
                              width: 50,
                              height: 50,
                            ),
                            title: Text(
                              medication['name'],
                              style: AppTextStyles.body1S16
                                  .copyWith(color: AppColors.gr900),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '제조사: ${medication['manufacturer']}',
                                  style: AppTextStyles.body5M14
                                      .copyWith(color: AppColors.gr600),
                                ),
                                Text(
                                  '분류: ${medication['category']}',
                                  style: AppTextStyles.body5M14
                                      .copyWith(color: AppColors.gr600),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                _favoriteStatus[index]
                                    ? Icons.star
                                    : Icons.star_border,
                                color: _favoriteStatus[index]
                                    ? AppColors.vibrantTeal
                                    : AppColors.gr500,
                              ),
                              onPressed: () {
                                _toggleFavorite(index);
                              },
                            ),
                          ),
                        ),
                        if (medication['isWarning'])
                          Card(
                            color: AppColors.gr200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning,
                                      color: Colors.orange),
                                  const SizedBox(width: 8.0),
                                  Text('000님의 질병에서 주의해야하는 약이에요',
                                      style: AppTextStyles.body5M14
                                          .copyWith(color: AppColors.gr800)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
