import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/constans/colors.dart'; // 색상 정의 파일을 임포트
import 'package:sopf_front/constans/text_styles.dart'; // 글꼴 스타일 정의 파일을 임포트
import 'package:sopf_front/managers/managers_favorites.dart';
import 'package:sopf_front/models/models_drug_info_detail.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/providers/provider.dart';
import 'package:sopf_front/screens/search/result/search_result.dart';
import 'package:sopf_front/services/services_auth.dart';
import 'package:sopf_front/services/services_favorite.dart';
import 'package:sopf_front/services/services_pill.dart';

import '../../../services/services_disease_allergy.dart';

class SearchResultPillDetail extends StatefulWidget {
  final int serialNumber;
  final String imgUrl;
  final String pillName;

  const SearchResultPillDetail({
    Key? key,
    required this.serialNumber,
    required this.imgUrl,
    required this.pillName,
  }) : super(key: key);

  @override
  _SearchResultPillDetailState createState() => _SearchResultPillDetailState();
}

class _SearchResultPillDetailState extends State<SearchResultPillDetail> {
  bool showWarning = false; // 초기에는 주의사항을 보이게 설정
  bool isFavorite = false; // 즐겨찾기 상태
  final PillService pillService = PillService();
  bool isBookmarked = false; // 즐겨찾기 상태
  final AuthService authService = AuthService();
  final FavoriteService favoriteService = FavoriteService(); // 즐겨찾기 서비스 인스턴스
  List<String> allergies = []; // 알레르기 목록

  @override
  void initState() {
    super.initState();
    _loadBookmarkStatus(); // 초기 즐겨찾기 상태 로드
    _loadAllergies();
  }

  Future<void> _loadAllergies() async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    if (currentProfile == null) return;

    try {
      final result = await DiseaseAllergyService().diseaseAllergyGet(context);
      setState(() {
        allergies = result ?? []; // null이면 빈 리스트를 사용
        allergies.add('감기'); // 샘플 알레르기 단어 추가
      });
    } catch (e) {
      print('Error loading allergies: $e');
    }
  }

  // 즐겨찾기 상태를 서버에서 로드하는 함수
  void _loadBookmarkStatus() async {
    await favoriteService.favoriteGet(context); // 즐겨찾기 목록을 서버에서 가져옴
    var favorites = FavoritesManager().favorites; // FavoritesManager에서 즐겨찾기 목록 가져오기
    setState(() {
      isBookmarked = favorites.any((favorite) => favorite.serialNumber == widget.serialNumber); // 목록에 해당 항목이 있는지 확인
    });
  }

  void _toggleBookmark() async {
    try {
      if (isBookmarked) {
        // 즐겨찾기 삭제 요청
        await favoriteService.favoriteDelete(context, widget.serialNumber);
        print('즐겨찾기 삭제 성공');
      } else {
        // 즐겨찾기 추가 요청
        await favoriteService.favoritePost(context, widget.serialNumber, widget.imgUrl);
        print('즐겨찾기 추가 성공');
      }

      // 상태 업데이트 및 UI 새로고침
      setState(() {
        isBookmarked = !isBookmarked; // 즐겨찾기 상태 토글
        print('상태 변경: $isBookmarked');
      });
    } catch (e) {
      // 오류 메시지 출력
      print('즐겨찾기 상태 변경 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDrugInfoDetail = Provider.of<DrugInfoDetailProvider>(context, listen: false).currentDrugInfoDetail;
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;

    return Scaffold(
      appBar: AppBar(
        title: Text('알약 상세 정보', style: AppTextStyles.body1S16),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResult(searchKeyword: ''), // SearchResult 페이지로 이동
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      '복용 중인 알약으로 추가할까요?',
                      style: AppTextStyles.body2M16,
                      selectionColor: AppColors.gr800,
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      '홈, 마이페이지에 등록됩니다',
                      style: AppTextStyles.body5M14,
                      selectionColor: AppColors.gr600,
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.gr250,
                          minimumSize: Size(120, 44),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        child: Text(
                          '취소',
                          style: AppTextStyles.body1S16,
                          selectionColor: AppColors.gr600,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          await pillService.pillPost(context, widget.serialNumber);
                          navigateToHome();
                          // 초기화 로직을 추가하세요.
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.softTeal,
                          minimumSize: Size(120, 44),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        child: Text(
                          '추가',
                          style: AppTextStyles.body1S16.copyWith(color: AppColors.gr600),
                          selectionColor: AppColors.deepTeal,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add, size: 30),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Stack(
            children: [
              Image.network(widget.imgUrl, fit: BoxFit.cover),
              Positioned(
                right: 8.0,
                bottom: 8.0,
                child: IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.star : Icons.star_border,
                    color: isBookmarked ? AppColors.vibrantTeal : Colors.grey,
                  ),
                  onPressed: _toggleBookmark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            currentDrugInfoDetail?.enterpriseName ?? 'Unknown Company',
            style: AppTextStyles.body3S15.copyWith(color: AppColors.vibrantTeal),
          ),
          const SizedBox(height: 8.0),
          Text(widget.pillName, style: AppTextStyles.title2B20),
          const SizedBox(height: 8.0),
          Visibility(
            visible: showWarning,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.gr100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.yellow),
                  const SizedBox(width: 8.0),
                  Text(
                    '주의: 사용자께서 주의해야하시는 알약입니다.',
                    style: AppTextStyles.body5M14.copyWith(color: AppColors.bk),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text('성분', style: AppTextStyles.body4S14),
          const SizedBox(height: 4.0),
          Text(
            currentDrugInfoDetail?.material ?? 'No material information',
            style: AppTextStyles.body5M14,
          ),
          const SizedBox(height: 20.0),
          buildDetailSection('효능효과', currentDrugInfoDetail?.efficacyEffect),
          const SizedBox(height: 20.0),
          buildDetailSection('용법용량', currentDrugInfoDetail?.dosageUsage),
          const SizedBox(height: 20.0),
          buildDetailSection('주의사항', currentDrugInfoDetail?.cautionGeneral, true), // 주의사항일 때만 true 전달
        ],
      ),
    );
  }

  Widget buildDetailSection(String title, DetailSection? section, [bool isCaution = false]) {
    if (section == null) {
      return Text(
        '$title 정보 없음',
        style: AppTextStyles.body5M14,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.body4S14,
        ),
        ...?section.sectionList?.map((subSection) => buildDetailSection(subSection.title!, subSection, isCaution)).toList(),
        ...?section.articleList?.map((article) => buildArticle(article, isCaution)).toList(),
      ],
    );
  }

  Widget buildArticle(Article article, bool isCaution) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (article.title != null)
          Text(
            article.title!,
            style: AppTextStyles.body5M14,
          ),
        ...?article.paragraphList?.map((paragraph) => Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 4.0),
          child: paragraph.description != null
              ? isCaution
              ? buildHighlightedText(paragraph.description!) // 주의사항이면 하이라이트
              : Text(paragraph.description!) // 주의사항이 아니면 일반 텍스트
              : Text(''),
        )).toList(),
      ],
    );
  }

  // Helper function to build the highlighted text
  RichText buildHighlightedText(String paragraph) {
    List<TextSpan> spans = [];
    bool foundAllergy = false; // 알레르기 단어 발견 여부

    final words = paragraph.split(' ');

    for (var word in words) {
      bool isAllergyWord = allergies.any((allergy) => word.toLowerCase().contains(allergy.toLowerCase())); // 알레르기 체크

      if (isAllergyWord) {
        foundAllergy = true; // 알레르기 단어가 발견되면 true로 설정
      }

      spans.add(TextSpan(
        text: '$word ', // 각 단어 뒤에 공백 추가
        style: isAllergyWord
            ? AppTextStyles.body5M14.copyWith(
          backgroundColor: Colors.yellow, // 하이라이트 배경 적용
          color: AppColors.bk, // 글꼴 색상 설정
        )
            : AppTextStyles.body5M14.copyWith(
          backgroundColor: null,
          color: AppColors.bk,
        ), // 알레르기 단어가 아닌 경우 스타일 없음
      ));
    }

    // 알레르기 단어가 발견되면 showWarning을 true로 설정
    if (foundAllergy && !showWarning) {
      setState(() {
        showWarning = true;
        print('알레르기 단어가 발견되어 주의 사항을 활성화했습니다.');
      });
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
