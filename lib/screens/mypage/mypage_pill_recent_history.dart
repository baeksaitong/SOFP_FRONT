// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/widgets/common/custom_appbar.dart';
import 'package:sopf_front/widgets/mypage/info_tile.dart';

class MyPagePillRecentHistory extends StatelessWidget {
  const MyPagePillRecentHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '복용 이력'),
      body: ListView(
        children: [
          InfoTile(title: '복용 이력 1', subtitle: '설명 1'),
          InfoTile(title: '복용 이력 2', subtitle: '설명 2'),
          InfoTile(title: '복용 이력 3', subtitle: '설명 3'),
        ],
      ),
    );
  }
}
