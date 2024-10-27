// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/screens/search/search_image.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/services/services_search.dart';
import '../../constans/text_styles.dart';
import '../../constans/gaps.dart';

class SearchText extends StatefulWidget {
  const SearchText({super.key});

  @override
  State<SearchText> createState() => _SearchTextState();
}

class _SearchTextState extends State<SearchText> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: navigateToTextSearchDetail,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '약을 검색해 보세요',
                style: AppTextStyles.title3S18,
              ),
              Gaps.h16,
              Container(
                width: 335,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.wh,
                  borderRadius: BorderRadius.circular(16.0), // 둥근 모서리를 만들기
                ),
                child: Row(
                  children: [
                    Gaps.w16,
                    Image.asset(
                      'assets/ion_search.png',
                      width: 20,
                      height: 20,
                    ),
                    Gaps.w6,
                    Expanded(
                      child: Text(
                        '알약 이름을 검색해 보세요',
                        style: AppTextStyles.body5M14
                            .copyWith(color: AppColors.gr500),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _requestCameraPermissionAndNavigate(context);
                      },
                      icon: Image.asset(
                        'assets/majesticons_camera.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        loadingOverlay(context), // Add the loading overlay here
      ],
    );
  }

  void _requestCameraPermissionAndNavigate(BuildContext context) async {
    // 카메라 권한 요청
    final status = await Permission.camera.request();

    if (status.isGranted) {
      try {
        // 약간의 지연 후 카메라 초기화
        await Future.delayed(Duration(milliseconds: 300));

        // 권한이 허용된 경우 사용 가능한 카메라 목록을 가져옴
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          // 카메라가 있는 경우 ImageSearch 화면으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchImage(cameras: cameras),
            ),
          );
        } else {
          // 카메라가 없는 경우 사용자에게 알림
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('사용 가능한 카메라가 없습니다.')),
          );
        }
      } catch (e) {
        // 카메라 초기화 중에 발생한 예외 처리
        logger.e('카메라 초기화 오류: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('카메라를 초기화하는 동안 오류가 발생했습니다.')),
        );
      }
    } else {
      // 권한이 거부된 경우 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카메라 권한이 필요합니다. 설정에서 허용해주세요.')),
      );
    }
  }
}


class TextSearchDetail extends StatefulWidget {
  const TextSearchDetail({super.key});

  @override
  State<TextSearchDetail> createState() => _TextSearchDetailState();
}

class _TextSearchDetailState extends State<TextSearchDetail> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final SearchService searchService = SearchService();

  final List<String> _recentSearches = [];

  void _addSearchTerm(String term) async {
    if (term.isNotEmpty) {
      showLoading(context, delayed: true); // Show loading spinner with delay

      await searchService.searchTextAndShape(
          context, term, null, null, null, null, null, null);

      setState(() {
        _recentSearches.remove(term);
        _recentSearches.insert(
            0, term); // Add new search term to the beginning of the list
        _controller.clear();
        _focusNode.requestFocus();
        // Request focus back to the text field
        navigateToSearchResult(term);
      });

      hideLoading(context); // Hide loading spinner
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
      body: Stack(
        children: [
          Container(
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
                            focusedBorder: InputBorder.none,
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
                        contentPadding: EdgeInsets.zero, // Remove padding inside ListTile
                        title: GestureDetector(
                          onTap: () {
                            // 최근 검색어를 눌렀을 때 해당 검색어로 다시 검색
                            _addSearchTerm(_recentSearches[index]);
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
          loadingOverlay(context), // Add the loading overlay here
        ],
      ),
    );
  }
}

