import 'package:flutter/material.dart';

class BottomDialog extends StatelessWidget {
  final void Function(Map<String, Color>, List<String>) onOptionSelected;

  const BottomDialog({
    Key? key,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement your bottom dialog content here
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Your bottom dialog content
        ],
      ),
    );
  }
}
