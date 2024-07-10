import 'package:flutter/material.dart';
import 'package:sopf_front/constans/colors.dart';

class SelectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final VoidCallback? onDeleted;

  const SelectionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool value) => onSelected(),
      backgroundColor: AppColors.gr150,
      selectedColor: AppColors.wh,
      checkmarkColor: AppColors.deepTeal,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.gr800 : AppColors.gr800,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: isSelected ? AppColors.deepTeal : AppColors.gr400,
        ),
      ),
      onDeleted: onDeleted,
    );
  }
}
