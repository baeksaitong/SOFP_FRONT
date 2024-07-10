// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/widgets/common/custom_appbar.dart';
import 'package:sopf_front/widgets/mypage/info_tile.dart';

class MyPageServiceCenter extends StatelessWidget {
  const MyPageServiceCenter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '서비스 센터'),
      body: ListView(
        children: [
          InfoTile(title: '서비스 센터 1', subtitle: '설명 1'),
          InfoTile(title: '서비스 센터 2', subtitle: '설명 2'),
          InfoTile(title: '서비스 센터 3', subtitle: '설명 3'),
        ],
      ),
    );
  }
}
