// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/constans/gaps.dart';
import '../../../managers/apiClient.dart';
import '../../../managers/globalResponseManager.dart';
import '../../../home.dart';
import '../../../navigates.dart';

class SearchResultPage extends StatefulWidget {
  final XFile? firstImageFile;
  final XFile? secondImageFile;

  const SearchResultPage({super.key, this.firstImageFile, this.secondImageFile});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List<DrugInfo> drugs = [];
  List<FavoriteInfo> favorites = [];
  APIClient apiClient = APIClient();

  void _toggleBookmark(int index) {
    setState(() {
      drugs[index].isBookmarked = !drugs[index].isBookmarked;
      print('${drugs[index].serialNumber}, ${drugs[index].imgUrl}');
      if (drugs[index].isBookmarked == true) {
        apiClient.favoritePost(
            context, drugs[index].serialNumber, drugs[index].imgUrl);
      } else {
        apiClient.favoriteDelete(context, drugs[index].serialNumber);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeDrugs();
  }

  void _initializeDrugs() async{
    showLoading(context, delayed: true); // Show loading spinner with delay

    await apiClient.searchTextAndShape(context, '타이레놀', null, null, null, null, null);

    hideLoading(context); // Hide loading spinner

    favorites = FavoritesManager().favorites;
    drugs = DrugsManager().drugs; // GlobalManager에서 직접 데이터를 가져옵니다.
    for (var drug in drugs) {
      for (var favorite in favorites) {
        if (drug.serialNumber == favorite.serialNumber) {
          drug.isBookmarked = true;
          break;
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 결과', style: AppTextStyles.body1S16),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            ); // **뒤로 가기 동작**
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          widget.firstImageFile != null
                              ? Image.file(
                            File(widget.firstImageFile!.path), // **첫 번째 이미지**
                            width: 100,
                            height: 100,
                          )
                              : Container(),
                          Gaps.w8,
                          widget.secondImageFile != null
                              ? Image.file(
                            File(widget.secondImageFile!.path), // **두 번째 이미지**
                            width: 100,
                            height: 100,
                          )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                Text(
                  '촬영된 사진의 검색 결과 4건',
                  style: AppTextStyles.body2M16,
                ),
                Gaps.h8,
                Expanded(
                  child: ListView.separated(
                    itemCount: drugs.length,
                    itemBuilder: (context, index) {
                      final drug = drugs[index];
                      return GestureDetector(
                        onTap: () async {
                          await apiClient.searchGet(context, drug.serialNumber);
                          navigateToPillDetail(drug.serialNumber);
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
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () => _toggleBookmark(index),
                                  child: Image.asset(
                                    drug.isBookmarked
                                        ? 'assets/bookmarkclicked.png'
                                        : 'assets/bookmark.png',
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
                    }, separatorBuilder: (context, index) => Gaps.h8,),
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
