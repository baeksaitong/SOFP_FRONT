import 'package:flutter/material.dart';

class SearchResultImageTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const SearchResultImageTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
