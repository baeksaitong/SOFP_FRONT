import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/gaps.dart';
import 'package:sopf_front/shapeSearch.dart';
import 'package:sopf_front/textSearch.dart';

import 'appTextStyles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0; // 키보드 위치 확인

    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
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
                      Spacer(), // Flexible space
                      Image.asset(
                        'assets/two_transparent_capsules.png',
                        width: 42,
                        height: 60,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/mypage_pill.png',
                        width: 28,
                        height: 28,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '복용 중인 약',
                        style: AppTextStyles.body5M14,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/mypage_allergy.png',
                        width: 28,
                        height: 28,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '알레르기 현황',
                        style: AppTextStyles.body5M14,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.gr150,
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  TextSearch(),
                  Gaps.h20,
                  ShapeSearch(),
                ],
              ),
            ),
          ],
        ),
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
      floatingActionButton: isKeyboardVisible ? null : SizedBox(
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