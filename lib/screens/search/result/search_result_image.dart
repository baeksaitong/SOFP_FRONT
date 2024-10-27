import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path; // 파일 경로에서 이름과 확장자를 얻기 위한 패키지

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/screens/search/search_image.dart';
import '../../../managers/managers_drugs.dart';
import '../../../managers/managers_favorites.dart';
import '../../../services/services_favorite.dart';
import '../../../services/services_search.dart';
import '../../../home.dart';
import '../../../models/models_drug_info.dart';
import '../../../models/models_favorite_info.dart';
import '../../../navigates.dart';

class SearchResultImage extends StatefulWidget {
  final XFile? firstImageFile;
  final XFile? secondImageFile;
  final List<CameraDescription> cameras;

  const SearchResultImage({super.key, this.firstImageFile, this.secondImageFile, required this.cameras});

  @override
  _SearchResultImageState createState() => _SearchResultImageState();
}

class _SearchResultImageState extends State<SearchResultImage> {
  List<DrugInfo> drugs = [];
  List<FavoriteInfo> favorites = [];
  final FavoriteService favoriteService = FavoriteService();
  final SearchService searchService = SearchService();

  void _toggleBookmark(int index) {
    setState(() {
      drugs[index].isBookmarked = !drugs[index].isBookmarked;
      if (drugs[index].isBookmarked == true) {
        favoriteService.favoritePost(
            context, drugs[index].serialNumber, drugs[index].imgUrl);
      } else {
        favoriteService.favoriteDelete(context, drugs[index].serialNumber);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // 첫 번째 이미지 파일 정보 출력
    if (widget.firstImageFile != null) {
      String firstFileName = path.basename(widget.firstImageFile!.path);
      String firstFileExtension = path.extension(widget.firstImageFile!.path);
      print("First Image File Name: $firstFileName");
      print("First Image File Name: $firstFileName");
      print("First Image File Extension: $firstFileExtension");
    }

    // 두 번째 이미지 파일 정보 출력
    if (widget.secondImageFile != null) {
      String secondFileName = path.basename(widget.secondImageFile!.path);
      String secondFileExtension = path.extension(widget.secondImageFile!.path);
      print("Second Image File Name: $secondFileName");
      print("Second Image File Extension: $secondFileExtension");
    }

    _initializeDrugs();
  }

  void _initializeDrugs() async {
    showLoading(context, delayed: true); // 로딩 표시

    await searchService.searchImagePost(context, widget.firstImageFile, widget.secondImageFile);

    hideLoading(context); // 로딩 숨기기

    favorites = FavoritesManager().favorites;
    drugs = DrugsManager().drugs;
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

  void _retakePhotos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchImage(cameras: widget.cameras),
      ),
    );
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
            );
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

                // 이미지 Row 부분
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          widget.firstImageFile != null
                              ? Image.file(
                            File(widget.firstImageFile!.path),
                            width: 100,
                            height: 100,
                          )
                              : Container(),
                          Gaps.w8,
                          widget.secondImageFile != null
                              ? Image.file(
                            File(widget.secondImageFile!.path),
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

                // 검색 결과와 재촬영하기 버튼을 나란히 배치
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '촬영된 사진의 검색 결과 ${drugs.length}건',
                      style: AppTextStyles.title2B20,
                    ),
                    Container(
                      width: 86,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.vibrantTeal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: _retakePhotos,
                        child: Text(
                          '재촬영하기',
                          style: AppTextStyles.body5M14.copyWith(
                            color: AppColors.softTeal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Gaps.h24,

                Expanded(
                  child: ListView.separated(
                    itemCount: drugs.length,
                    itemBuilder: (context, index) {
                      final drug = drugs[index];
                      return GestureDetector(
                        onTap: () async {
                          await searchService.searchGet(context, drug.serialNumber);
                          navigateToPillDetail(context, drug.serialNumber, drug.imgUrl, drug.name);
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
                    },
                    separatorBuilder: (context, index) => Gaps.h8,
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
