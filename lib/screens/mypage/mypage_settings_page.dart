// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/widgets/common/custom_appbar.dart';
import 'package:sopf_front/widgets/mypage/settings_tile.dart';

class MyPageSettingsPage extends StatelessWidget {
  const MyPageSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '설정'),
      body: ListView(
        children: [
          SettingsTile(title: '알림 설정', onTap: () {
            // 알림 설정 페이지로 이동
          }),
          SettingsTile(title: '계정 설정', onTap: () {
            // 계정 설정 페이지로 이동
          }),
          SettingsTile(title: '테마 설정', onTap: () {
            // 테마 설정 페이지로 이동
          }),
          SettingsTile(title: '기타 설정', onTap: () {
            // 기타 설정 페이지로 이동
          }),
        ],
      ),
    );
  }
}
