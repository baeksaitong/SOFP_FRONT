// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/services/services_pill.dart';
import 'package:sopf_front/services/services_search.dart';
import '../../constans/text_styles.dart';
import '../../constans/gaps.dart';
import '../../managers/managers_recent_histories.dart';
import '../../models/models_recent_history_info.dart';
import '../../navigates.dart';

class MyPagePillRecentHistory extends StatefulWidget {
  const MyPagePillRecentHistory({super.key});

  @override
  State<MyPagePillRecentHistory> createState() => _MyPagePillRecentHistoryState();
}

class _MyPagePillRecentHistoryState extends State<MyPagePillRecentHistory> {
  List<RecentHistoryInfo> recentHistories = [];
  final PillService pillService = PillService();
  final SearchService searchService = SearchService();

  @override
  void initState() {
    super.initState();
    _loadRecentHistoryDrugs();
  }

  Future<void> _loadRecentHistoryDrugs() async {
    await pillService.recentViewPillGet(context);
    setState(() {
      recentHistories = RecentHistoriesManager().recentHistories;
    });
  }

  Future<void> _recentDelete(int index) async {
    bool success = await pillService.recentViewPillDelete(recentHistories[index].serialNumber, context);
    if (success) {
      setState(() {
        recentHistories.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.wh,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Container(
        color: AppColors.wh,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '최근 본 알약',
                style: AppTextStyles.title1B24.copyWith(color: AppColors.gr800),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: recentHistories.length,
                itemBuilder: (context, index) {
                  final drug = recentHistories[index];
                  return GestureDetector(
                    onTap: () async {
                      await searchService.searchGet(context, drug.serialNumber);
                      navigateToPillDetail(
                          context,
                          drug.serialNumber,
                          drug.imgUrl,
                          drug.name,
                          "여기에 알약 설명을 추가하세요" // 알약 설명을 추가합니다.
                      );
                    },
                    child: Row(
                      children: [
                        Image.network(
                          drug.imgUrl,
                          width: 96,
                          height: 96,
                        ),
                        Gaps.w16,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                drug.name,
                                style: AppTextStyles.body1S16,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Gaps.h6,
                              Text(
                                '제품명 : ${drug.name}',
                                style: AppTextStyles.body5M14,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '제조회사 : ${drug.enterprise}',
                                style: AppTextStyles.body5M14,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '분류 : ${drug.classification}',
                                style: AppTextStyles.body5M14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _recentDelete(index),
                          child: Image.asset(
                            'assets/IconChat.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Gaps.h8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
