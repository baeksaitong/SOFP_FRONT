import 'package:flutter/material.dart';

import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';

class TextSearch extends StatefulWidget {
  const TextSearch({super.key});

  @override
  State<TextSearch> createState() => _TextSearchState();
}

class _TextSearchState extends State<TextSearch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '약을 검색해 보세요',
          style: AppTextStyles.title3S18,
        ),
        Gaps.h16,
        Container(
          width: 335,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.wh,
            borderRadius: BorderRadius.circular(16.0), // 둥근 모서리를 만들기
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'assets/ion_search.png',
                  width: 20,
                  height: 20,
                ),
              ),
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "알약 이름을 검색해보세요",
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'assets/majesticons_camera.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
