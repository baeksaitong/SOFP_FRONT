import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/gaps.dart';
import 'package:sopf_front/shapeSearch.dart';

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
                child: ShapeSearch(),
              )
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.gr100,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                onPressed: () {},
                icon: Image.asset(
                    'assets/bottom_star.png',
                  width: 28,
                  height: 27,
                ),
            ),
            Gaps.w48,
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/bottom_user-bold.png',
                width: 28,
                height: 27,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.vibrantTeal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
          child: Image.asset(
            'assets/fluent_home-32-filled.png',
            width: 28,
            height: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.centerDocked, 0, 20
      ),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation location;
  final double offsetX; // Horizontal offset
  final double offsetY; // Vertical offset

  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}