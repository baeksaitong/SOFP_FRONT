import 'package:flutter/material.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/gaps.dart';

import 'appTextStyles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '000님\n좋은 하루 보내세요!',
                      style: AppTextStyles.title1B24,
                    ),
                    Gaps.w96,
                    Image.asset(
                      'assets/two_transparent_capsules.png',
                      width: 42,
                      height: 60,
                    ),
                  ],
                ),
                Gaps.h40,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/mypage_pill.png',
                      width: 28,
                      height: 28,
                    ),
                    Gaps.w8,
                    Text(
                      '복용 중인 약',
                      style: AppTextStyles.body5M14,
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/mypage_allergy.png',
                      width: 28,
                      height: 28,
                    ),
                    Gaps.w8,
                    Text(
                      '알레르기 현황',
                      style: AppTextStyles.body5M14,
                    ),
                  ],
                )
              ],
            ),
          ),
          Gaps.h16,
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gr150,
                  borderRadius: BorderRadius.circular(16.0), // 둥근 모서리를 만들기
                  // 원을 만들고 싶다면 width와 height를 같게 하고, borderRadius의 값을 두 축의 길이의 반으로 설정합니다.
                ),
              )
          ),
        ],
      ),

    );
  }
}
