import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/gaps.dart';
import 'package:sopf_front/provider.dart';
import 'package:sopf_front/shapeSearch.dart';
import 'package:sopf_front/textSearch.dart';
import 'package:sopf_front/mypage.dart';
import 'package:sopf_front/calenderFirstPage.dart';
import 'appTextStyles.dart';

import 'apiClient.dart';
import 'appTextStyles.dart';
import 'globalResponseManager.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    Placeholder(), // PharmacyMap 구현되면 교체
    HomePageContent(),
    CalendarApp(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0; // 키보드 위치 확인
    final currentProfile = Provider.of<ProfileProvider>(context).currentProfile;

    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        backgroundColor: AppColors.wh,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        isKeyboardVisible: isKeyboardVisible,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                Gaps.h40,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/mypage_pill.png',
                      width: 28,
                      height: 28,
                    ),
                    Gaps.h8,
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
                    Gaps.h8,
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
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;
  final bool isKeyboardVisible;

  CustomBottomNavigationBar({
    required this.onTap,
    required this.currentIndex,
    required this.isKeyboardVisible,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = MediaQuery.of(context).size.width * 0.07; // Adjust icon size dynamically
    final double textSize = MediaQuery.of(context).size.width * 0.03; // Adjust text size dynamically

    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(0, '약국', 'assets/bottombar/IconGnbHome.png', 'assets/bottombar/IconGnbHome_bk.png', iconSize, textSize),
          _buildNavItem(1, '홈', 'assets/bottombar/IconGnbSale.png', 'assets/bottombar/IconGnbSale_bk.png', iconSize, textSize),
          _buildNavItem(2, '캘린더', 'assets/bottombar/IconGnbBuyer.png', 'assets/bottombar/IconGnbBuyer_bk.png', iconSize, textSize),
          _buildNavItem(3, '마이', 'assets/bottombar/IconBtnMoreActive.png', 'assets/bottombar/IconBtnMoreActive_bk.png', iconSize, textSize),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath, String selectedIconPath, double iconSize, double textSize) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Image.asset(
                currentIndex == index ? selectedIconPath : iconPath,
                width: iconSize,
                height: iconSize,
              ),
            ),
            Gaps.h4,
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: currentIndex == index ? AppColors.gr800 : AppColors.gr400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
