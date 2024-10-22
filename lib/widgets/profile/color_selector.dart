// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:sopf_front/constans/colors.dart';

class ColorSelector extends StatelessWidget {
  final Function(String) onColorSelected;

  const ColorSelector({required this.onColorSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('색상 선택', style: TextStyle(color: AppColors.gr400)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildColorButton(context, 'Red', AppColors.red),
            _buildColorButton(context, 'Green', AppColors.deepTeal),
            _buildColorButton(context, 'Blue', AppColors.deepBlue),
            // 필요한 색상 추가
          ],
        ),
      ],
    );
  }

  Widget _buildColorButton(BuildContext context, String colorName, Color color) {
    return GestureDetector(
      onTap: () {
        onColorSelected(colorName);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
