import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/gaps.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/provider.dart';
import 'package:sopf_front/shapeSearch.dart';
import 'package:sopf_front/textSearch.dart';
import 'package:sopf_front/mypage.dart';
import 'package:sopf_front/calenderFirstPage.dart';
import 'appTextStyles.dart';
import 'apiClient.dart';
import 'appTextStyles.dart';
import 'globalResponseManager.dart';
import 'package:flutter/services.dart';

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


  void _showBottomSheet(BuildContext context) {
    HapticFeedback.vibrate(); // 진동 추가
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: AppColors.wh,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.h20,
                  Text(
                    '멀티 프로필',
                    style: AppTextStyles.title3S18.copyWith(color: AppColors.gr800),
                  ),
                  Gaps.h16,
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // 스크롤을 비활성화하여 부모 스크롤과 충돌 방지
                    itemCount: profileProvider.profileList.length,
                    itemBuilder: (context, index) {
                      final profile = profileProvider.profileList[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              profileProvider.setCurrentProfile(profile);
                              Navigator.pop(context); // Close the bottom sheet
                              setState(() {
                                _selectedIndex=3;
                              });
                            },
                            child: Container(
                              height: 48,
                              color: AppColors.gr150,
                              child: Row(
                                children: [
                                  Container(
                                    width: 2,
                                    color: getColorFromText(profile.color),
                                  ),
                                  Gaps.w12,
                                  CircleAvatar(
                                    backgroundColor: getColorFromText(profile.color),
                                    radius: 10,
                                    // backgroundImage: NetworkImage(profile.imgURL), // assuming profile.imgURL is a URL
                                  ),
                                  Gaps.w12,
                                  Text(
                                    profile.name,
                                    style: AppTextStyles.body2M16.copyWith(color: AppColors.gr900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index != profileProvider.profileList.length - 1) Gaps.h10,
                        ],
                      );
                    },
                  ),
                  Center(
                    child: Container(
                      width: 335,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          // 프로필 추가하기 버튼 클릭 시 동작
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.softTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '프로필 추가하기',
                          style: AppTextStyles.body1S16.copyWith(color: AppColors.vibrantTeal),
                        ),
                      ),
                    ),
                  ),
                  Gaps.h24,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0; // 키보드 위치 확인
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
        onLongPress: () => _showBottomSheet(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
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
                      '${currentProfile?.name}\n좋은 하루 보내세요!',
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors
                        .transparent, // Make the button background transparent
                    shadowColor: Colors.transparent, // Remove the button shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Define the action for the button press here
                    navigateToMedicationsTaking();
                  },
                  child: Row(
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
  final void Function() onLongPress; // onLongPress 콜백 변경
  final int currentIndex;
  final bool isKeyboardVisible;

  CustomBottomNavigationBar({
    super.key,
    required this.onTap,
    required this.onLongPress, // onLongPress 콜백 추가
    required this.currentIndex,
    required this.isKeyboardVisible,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = MediaQuery.of(context).size.width *
        0.07; // Adjust icon size dynamically
    final double textSize = MediaQuery.of(context).size.width *
        0.03; // Adjust text size dynamically

    return BottomAppBar(
      color: AppColors.wh,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(0, '약국', 'assets/bottombar/IconGnbHome.png',
              'assets/bottombar/IconGnbHome_bk.png', iconSize, textSize),
          _buildNavItem(1, '홈', 'assets/bottombar/IconGnbSale.png',
              'assets/bottombar/IconGnbSale_bk.png', iconSize, textSize),
          _buildNavItem(2, '캘린더', 'assets/bottombar/IconGnbBuyer.png',
              'assets/bottombar/IconGnbBuyer_bk.png', iconSize, textSize),
          _buildNavItem(3, '마이', 'assets/bottombar/IconBtnMoreActive.png',
              'assets/bottombar/IconBtnMoreActive_bk.png', iconSize, textSize, isMyIcon: true),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath,
      String selectedIconPath, double iconSize, double textSize,
      {bool isMyIcon = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        onLongPress: isMyIcon ? onLongPress : null, // "마이" 아이콘에만 onLongPress 추가
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
                color:
                    currentIndex == index ? AppColors.gr800 : AppColors.gr400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
