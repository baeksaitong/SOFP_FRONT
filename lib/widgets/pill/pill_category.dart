import 'package:flutter/material.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/constans/text_styles.dart';

class PillCategoryForm extends StatefulWidget {
  final TextEditingController categoryNameController;
  final VoidCallback onSave;

  const PillCategoryForm({
    super.key,
    required this.categoryNameController,
    required this.onSave,
  });

  @override
  _PillCategoryFormState createState() => _PillCategoryFormState();
}

class _PillCategoryFormState extends State<PillCategoryForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.categoryNameController,
          decoration: InputDecoration(labelText: '카테고리 이름'),
        ),
        Gaps.h16,
        ElevatedButton(
          onPressed: widget.onSave,
          child: Text('저장'),
        ),
      ],
    );
  }
}
