import 'package:flutter/material.dart';

class PillListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const PillListItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
