// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';

class ProfileImagePicker extends StatelessWidget {
  final Function(String) onImageSelected;

  const ProfileImagePicker({required this.onImageSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('프로필 이미지', style: TextStyle(color: AppColors.gr400)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // 이미지 선택 로직
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.gr100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.camera_alt, color: AppColors.gr400),
          ),
        ),
      ],
    );
  }
}
