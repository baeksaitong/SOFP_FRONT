// lib/screens/multi_profile/multi_profile_add.dart

import 'package:flutter/material.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/constans/text_styles.dart';

class MultiProfileAdd extends StatefulWidget {
  @override
  _MultiProfileAddState createState() => _MultiProfileAddState();
}

class _MultiProfileAddState extends State<MultiProfileAdd> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        title: Text('Multi Profile Add'),
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
