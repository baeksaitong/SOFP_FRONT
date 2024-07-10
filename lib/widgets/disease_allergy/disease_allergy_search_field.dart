import 'package:flutter/material.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';

class SearchField extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;

  const SearchField({super.key, required this.query, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: AppColors.gr250,
        hintText: '질병 또는 알레르기를 검색해 보세요',
        hintStyle: AppTextStyles.body5M14,
      ),
    );
  }
}
