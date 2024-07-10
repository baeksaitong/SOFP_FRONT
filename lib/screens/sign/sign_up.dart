// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/widgets/common/custom_appbar.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '회원가입'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '이름',
                labelStyle: TextStyle(color: AppColors.gr400),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr400),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr800),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '이메일',
                labelStyle: TextStyle(color: AppColors.gr400),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr400),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr800),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                labelStyle: TextStyle(color: AppColors.gr400),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr400),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr800),
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // 회원가입 로직
              },
              child: Text('회원가입', style: AppTextStyles.body1S16),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.softTeal,
                foregroundColor: AppColors.deepTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
