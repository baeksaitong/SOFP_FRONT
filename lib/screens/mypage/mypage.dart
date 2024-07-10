// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/widgets/common/custom_appbar.dart';
import 'package:sopf_front/widgets/mypage/settings_tile.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '마이페이지'),
      body: ListView(
        children: [
          SettingsTile(title: '프로필 수정', onTap: () {
            // 프로필 수정 페이지로 이동
          }),
          SettingsTile(title: '북마크', onTap: () {
            // 북마크 페이지로 이동
          }),
          SettingsTile(title: '복용 이력', onTap: () {
            // 복용 이력 페이지로 이동
          }),
          SettingsTile(title: '서비스 센터', onTap: () {
            // 서비스 센터 페이지로 이동
          }),
          SettingsTile(title: '설정', onTap: () {
            // 설정 페이지로 이동
          }),
        ],
      ),
    );
  }
}
