import 'package:flutter/material.dart';
import 'package:sopf_front/constans/colors.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
