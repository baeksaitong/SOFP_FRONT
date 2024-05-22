import 'package:flutter/material.dart';
import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';

class TextSearchDetail extends StatefulWidget {
  final String initialSearchText;

  const TextSearchDetail({super.key, required this.initialSearchText});

  @override
  State<TextSearchDetail> createState() => _TextSearchDetailState();
}

class _TextSearchDetailState extends State<TextSearchDetail> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSearchText);
  }

  void _addSearchTerm(String term) {
    if (term.isNotEmpty) {
      setState(() {
        _recentSearches.remove(term);
        _recentSearches.insert(
            0, term); // Add new search term to the beginning of the list
        _controller.clear();
        _focusNode.requestFocus(); // Request focus back to the text field
        // navigateToSearchResult(); // You can implement navigation to search result here
      });
    }
  }

  void _removeSearchTerm(int index) {
    setState(() {
      _recentSearches.removeAt(index); // Remove search term by index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        backgroundColor: AppColors.wh,
        title: Text(
          '알약 검색',
          style: AppTextStyles.body1S16,
        ),
        leading: IconButton(
          icon: Image.asset(
            'assets/IconHeaderLeft.png',
            width: 20,
            height: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: 335,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 335,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.gr150,
                borderRadius: BorderRadius.circular(16.0), // 둥근 모서리를 만들기
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/ion_search.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "알약 이름을 검색해보세요",
                      ),
                      onSubmitted: _addSearchTerm,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.h24,
            Text(
              '최근검색',
              style: AppTextStyles.caption1M12,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _recentSearches.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding:
                        EdgeInsets.zero, // Remove padding inside ListTile
                    title: GestureDetector(
                      onTap: () {
                        print(_recentSearches[index]);
                      },
                      child: Text(
                        _recentSearches[index],
                        style: AppTextStyles.body5M14,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Image.asset(
                        'assets/IconChat.png',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () => _removeSearchTerm(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
