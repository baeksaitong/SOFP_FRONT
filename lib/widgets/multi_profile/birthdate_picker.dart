// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';

class ProfileImagePicker extends StatelessWidget {
  final Function(String) onImageSelected;

  const ProfileImagePicker({required this.onImageSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 이미지 선택 로직
        onImageSelected('image_url');
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.gr250,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(Icons.camera_alt, color: AppColors.gr400, size: 40),
            SizedBox(height: 8),
            Text('프로필 사진 선택', style: AppTextStyles.body2M16.copyWith(color: AppColors.gr600)),
          ],
        ),
      ),
    );
  }
}
