import 'package:flutter/material.dart';
import 'package:sopf_front/appcolors.dart';

import 'apiClient.dart';
import 'appTextStyles.dart';
import 'gaps.dart';
import 'globalResponseManager.dart';
import 'navigates.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final APIClient apiClient = APIClient();
  List<FavoriteInfo> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteDrugs();
  }

  Future<void> _loadFavoriteDrugs() async {
    await apiClient.favoriteGet(context);
    setState(() {
      favorites = FavoritesManager().favorites;
    });
  }

  void _toggleBookmark(int index) {
    setState(() {
      favorites[index].isBookmarked = !favorites[index].isBookmarked;
      print('${favorites[index].serialNumber}, ${favorites[index].imgUrl}');
      if (favorites[index].isBookmarked == true) {
        apiClient.favoritePost(context, favorites[index].serialNumber, favorites[index].imgUrl);
      } else {
        apiClient.favoriteDelete(context, favorites[index].serialNumber);
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
                      await apiClient.searchGet(context, drug.serialNumber);
                      navigateToPillDetail(drug.serialNumber);
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