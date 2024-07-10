import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackButtonPressed;

  const CustomAppBar({super.key, required this.title, this.onBackButtonPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBackButtonPressed != null
          ? IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: onBackButtonPressed,
      )
          : null,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
