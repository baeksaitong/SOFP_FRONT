// lib/screens/search/result/search_result_pill_detail.dart

import 'package:flutter/material.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/widgets/common/custom_appbar.dart';

class SearchResultPillDetail extends StatelessWidget {
  final int serialNumber;
  final String imgUrl;
  final String pillName;
  final String pillDescription;

  const SearchResultPillDetail({
    Key? key,
    required this.serialNumber,
    required this.imgUrl,
    required this.pillName,
    required this.pillDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알약 상세 정보'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(imgUrl),
            Text('이름: $pillName'),
            Text('설명: $pillDescription'),
          ],
        ),
      ),
    );
  }
}
