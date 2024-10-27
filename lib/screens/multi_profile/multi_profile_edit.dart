// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/constans/text_styles.dart';

class MultiProfileEdit extends StatefulWidget {
  @override
  _MultiProfileEditState createState() => _MultiProfileEditState();
}

class _MultiProfileEditState extends State<MultiProfileEdit> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        elevation: 0, // 그림자를 없애서 색 변화 방지
        title: Text('Multi Profile Edit'),
        backgroundColor: AppColors.vibrantTeal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: AppTextStyles.body2M16,
                border: OutlineInputBorder(),
              ),
            ),
            Gaps.h16,
            ElevatedButton(
              onPressed: () {
                // Save action
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.vibrantTeal,
                foregroundColor: AppColors.wh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
