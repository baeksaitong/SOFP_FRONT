import 'package:flutter/material.dart';

class SearchForm extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;
  final String hintText;

  const SearchForm({
    super.key,
    required this.searchController,
    required this.onSearch,
    this.hintText = '검색어를 입력하세요',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: hintText,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: onSearch,
        ),
      ],
    );
  }
}
