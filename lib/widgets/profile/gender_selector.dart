// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';

class GenderSelector extends StatelessWidget {
  final Function(String) onGenderSelected;

  const GenderSelector({required this.onGenderSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gr250,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('성별', style: AppTextStyles.body2M16.copyWith(color: AppColors.gr600)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  onGenderSelected('남성');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.wh,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.gr400),
                  ),
                  child: Text(
                    '남성',
                    style: AppTextStyles.body2M16.copyWith(color: AppColors.gr600),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onGenderSelected('여성');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.wh,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.gr400),
                  ),
                  child: Text(
                    '여성',
                    style: AppTextStyles.body2M16.copyWith(color: AppColors.gr600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
