import 'package:flutter/material.dart';

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
        title: const Text('즐겨찾기', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.separated(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final drug = favorites[index];
              return GestureDetector(
                onTap: () async{
                  await apiClient.searchGet(context, drug.serialNumber);
                  navigateToPillDetail();
                },
                child: Container(
                  width: 336,
                  height: 96,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        drug.imgUrl,
                        width: 96,
                        height: 96,
                      ),
                      Gaps.w16,
                      Container(
                        width: 200,
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
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () => _toggleBookmark(index),
                          child: Image.asset(
                            drug.isBookmarked ? 'assets/bookmarkclicked.png' : 'assets/bookmark.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      Gaps.h16,
                    ],
                  ),
                ),
              );
            }, separatorBuilder: (context, index) => Gaps.h8,
        ),
      )
    );
  }
}
