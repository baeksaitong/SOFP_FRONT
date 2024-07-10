// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/screens/pill/category_details.dart'; // CategoryDetails import

class PillCategoryDetail extends StatelessWidget {
  final CategoryDetails category;

  const PillCategoryDetail({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        title: Text(category.name), // 카테고리 이름을 제목으로 표시
        backgroundColor: AppColors.vibrantTeal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              category.description, // 카테고리 설명을 표시
              style: AppTextStyles.title1B24,
            ),
            Gaps.h16,
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Pill $index'),
                    subtitle: Text('Description of pill $index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
