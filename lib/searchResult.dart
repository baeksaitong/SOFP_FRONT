import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final TextEditingController _controller = TextEditingController();
  bool _isBookmarked = false;
  List<String> _resultSearches = [];

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        title: Text(
          '검색 결과',
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
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        width: 336,
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
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "알약 이름을 검색해보세요",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gaps.h24,
            Text(
              '검색 결과 0건',
              style: AppTextStyles.body5M14,
            ),
            Gaps.h12,
            Container(
              width: 336,
              height: 96,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                      'assets/exPill.png',
                    width: 96,
                    height: 96,
                  ),
                  Gaps.w16,
                  Container(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                            '가스디알정50밀리그램',
                          style: AppTextStyles.body1S16,
                          overflow: TextOverflow.clip,
                        ),
                        Gaps.h6,
                        Text(
                          '제품명 : 가스디알50밀리그램',
                          style: AppTextStyles.body5M14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '제조회사 : 일동제약',
                          style: AppTextStyles.body5M14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '분류 : 기타의소화기관용약 | 일반 의약품',
                          style: AppTextStyles.body5M14,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: _toggleBookmark,
                      child: Image.asset(
                        _isBookmarked ? 'assets/bookmarkclicked.png' : 'assets/bookmark.png',
                          width: 20,
                          height: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: _resultSearches.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         contentPadding: EdgeInsets.zero,  // Remove padding inside ListTile
            //         title: GestureDetector(
            //           onTap: () {print(_resultSearches[index]);},
            //           child: Text(
            //             _resultSearches[index],
            //             style: AppTextStyles.body5M14,
            //           ),
            //         ),
            //         trailing: IconButton(
            //           icon: Image.asset(
            //             'assets/bookmark.png',
            //             width: 24,
            //             height: 24,
            //           ),
            //           onPressed: () {},
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
