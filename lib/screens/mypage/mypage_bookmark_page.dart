// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/services/services_favorite.dart';
import 'package:sopf_front/services/services_search.dart';
import '../../constans/text_styles.dart';
import '../../constans/gaps.dart';
import '../../managers/managers_favorites.dart';
import '../../models/models_favorite_info.dart';
import '../../navigates.dart';

class MyPageBookMarkPage extends StatefulWidget {
  const MyPageBookMarkPage({super.key});

  @override
  State<MyPageBookMarkPage> createState() => _MyPageBookMarkPageState();
}

class _MyPageBookMarkPageState extends State<MyPageBookMarkPage> {
  late List<FavoriteInfo> favorites = [];
  final FavoriteService favoriteService = FavoriteService();
  final SearchService searchService = SearchService();

  @override
  void initState() {
    super.initState();
    _loadFavoriteDrugs();
  }

  Future<void> _loadFavoriteDrugs() async {
    await favoriteService.favoriteGet(context);
    setState(() {
      favorites = FavoritesManager().favorites;
    });
  }

  void _toggleBookmark(int index) {
    setState(() {
      favorites[index].isBookmarked = !favorites[index].isBookmarked;
      print('${favorites[index].serialNumber}, ${favorites[index].imgUrl}');
      if (favorites[index].isBookmarked == true) {
        favoriteService.favoritePost(context, favorites[index].serialNumber, favorites[index].imgUrl);
      } else {
        favoriteService.favoriteDelete(context, favorites[index].serialNumber);
      }
    });
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
                '즐겨찾기',
                style: AppTextStyles.title1B24.copyWith(color: AppColors.gr800),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final drug = favorites[index];
                  return GestureDetector(
                    onTap: () async {
                      await searchService.searchGet(context, drug.serialNumber);
                      navigateToPillDetail(
                          context,
                          drug.serialNumber,
                          drug.imgUrl,
                          drug.name,
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
                          onTap: () => _toggleBookmark(index),
                          child: Image.asset(
                            drug.isBookmarked ? 'assets/bookmarkclicked.png' : 'assets/bookmark.png',
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
