import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/gaps.dart';

import 'appTextStyles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textcontroller = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.wh,
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
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '약을 검색해 보세요',
                      style: AppTextStyles.title3S18,
                    ),
                    Gaps.h16,
                    Container(
                      width: 335,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.wh,
                        borderRadius: BorderRadius.circular(16.0), // 둥근 모서리를 만들기
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/ion_search.png',
                                width: 20,
                                height: 20,
                              ),
                          ),
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "알약 이름을 검색해보세요",
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                  'assets/majesticons_camera.png',
                                width: 24,
                                height: 24,
                              ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.h20,
                    Text(
                        '모양으로 찾기',
                      style: AppTextStyles.body5M14,
                    ),
                    Gaps.h8,
                    Container(
                      width: 335,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.wh,
                        borderRadius: BorderRadius.circular(16.0), // 둥근 모서리를 만들기
                      ),
                      child: Row(
                        children: const [
                          Gaps.w16,
                            Flexible(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "알약 이름을 검색해보세요",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gaps.h8,
                      SizedBox(
                        width: 78,
                        height: 78,
                        child: Column(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  width: 1,
                                  color: AppColors.wh,
                                ),
                                padding: EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                backgroundColor: AppColors.wh,
                              ),
                                onPressed: () {},
                                child: Column(
                                  children: [
                                    Image.asset(
                                        'assets/solar_pallete-2-bold-duotone.png',
                                      width: 32,
                                      height: 32,
                                    ),
                                    Text(
                                      '색상',
                                      style: AppTextStyles.body5M14,
                                    ),
                                  ],
                                ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}
