import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';

void main() {
  runApp(MaterialApp(
    title: '고객센터',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: CustomerServicePage(),
  ));
}

class CustomerServicePage extends StatefulWidget {
  const CustomerServicePage({super.key});

  @override
  _CustomerServicePageState createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        title: Text(
          '고객센터',
          style: AppTextStyles.body1S16.copyWith(color: AppColors.gr700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로 가기 버튼 기능
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이용하며 느끼신 불편한 점이나 바라는 점을 알려주세요.\n문의에 대한 답변은 24시간 이상 소요될 수 있으며, 등록된 이메일로 답변이 전송될 예정입니다.',
              style: AppTextStyles.body5M14.copyWith(color: AppColors.gr700),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: '내용을 입력해 주세요',
                  hintStyle:
                      AppTextStyles.body5M14.copyWith(color: AppColors.gr500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: AppColors.gr150,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  child: Text(
                    '파일 첨부',
                    style:
                        AppTextStyles.body5M14.copyWith(color: AppColors.gr700),
                  ),
                  onPressed: () {
                    // 파일 첨부 기능
                  },
                ),
                Text('이미지 첨부 10MB 이내, 3개까지 첨부 가능합니다.',
                    style: AppTextStyles.body5M14
                        .copyWith(color: AppColors.gr550)),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 문의 사항 전송 기능
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.softTeal, // 버튼 배경색
                  foregroundColor: AppColors.deepTeal, // 버튼 텍스트 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('보내기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
