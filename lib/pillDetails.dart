import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/provider.dart';
import 'appTextStyles.dart'; // 원하는 글꼴 스타일이 정의된 파일을 임포트
import 'appColors.dart'; // 색상 정의 파일을 임포트
import 'gaps.dart';
import 'globalResponseManager.dart';

class PillDetails extends StatefulWidget {
  const PillDetails({super.key});

  @override
  _PillDetailsState createState() => _PillDetailsState();
}

class _PillDetailsState extends State<PillDetails> {
  bool showWarning = true; // 초기에는 주의사항을 보이게 설정
  bool isFavorite = false; // 즐겨찾기 상태

  @override
  Widget build(BuildContext context) {
    final currentDrugInfoDetail = Provider.of<DrugInfoDetailProvider>(context, listen: false).currentDrugInfoDetail;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로 가기 버튼의 동작을 정의합니다.
            Navigator.pop(context);
          },
        ),
        title: Text(
            currentDrugInfoDetail?.name ?? 'No name available',
            style: AppTextStyles.body1S16
        ),
        centerTitle: true,
        actions: const [
          Icon(
              Icons.add,
            size: 30,
          ),
          Gaps.w8,
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/rect.png', // 약 이미지 파일 경로
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 8.0,
                bottom: 8.0,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? AppColors.vibrantTeal : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
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
          Text(
            currentDrugInfoDetail?.name ?? 'No name available',
            style: AppTextStyles.title2B20,
          ),
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
                    '000님의 질병에서 주의해야하는 약이에요',
                    style: AppTextStyles.body5M14.copyWith(color: AppColors.bk),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            '성분',
            style: AppTextStyles.body4S14,
          ),
          Gaps.h4,
          Text(
            currentDrugInfoDetail?.material ?? 'No material information',
            style: AppTextStyles.body5M14,
          ),
          Gaps.h20,
          buildDetailSection('효능효과', currentDrugInfoDetail?.efficacyEffect),
          Gaps.h20,
          buildDetailSection('용법용량', currentDrugInfoDetail?.dosageUsage),
          Gaps.h20,
          buildDetailSection('주의사항', currentDrugInfoDetail?.cautionGeneral),
        ],
      ),
    );
  }

  Widget buildDetailSection(String title, DetailSection? section) {
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
        // Gaps.h4,
        // if (section.title != null)
        //   Text(
        //     section.title!,
        //     style: AppTextStyles.body5M14,
        //   ),
        ...?section.sectionList?.map((subSection) => buildDetailSection(subSection.title!, subSection)).toList(),
        ...?section.articleList?.map((article) => buildArticle(article)).toList(),
      ],
    );
  }

  Widget buildArticle(Article article) {
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
          child: Text(
            paragraph.description ?? '',
            style: AppTextStyles.body5M14,
          ),
        )).toList(),
      ],
    );
  }
}
