// lib/screens/mypage/mypage_bookmark_page.dart
import 'package:flutter/material.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/widgets/common/custom_appbar.dart';

class MyPageBookMarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '북마크 페이지'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('북마크 아이템 1', style: AppTextStyles.body1S16),
            ),
            ListTile(
              title: Text('북마크 아이템 2', style: AppTextStyles.body1S16),
            ),
          ],
        ),
      ),
    );
  }
}
