// // Dart imports:
// import 'dart:convert';
//
// // Package imports:
// import 'package:html/parser.dart' show parse;
//
// class GlobalResponseManager {
//   static final GlobalResponseManager _instance =
//       GlobalResponseManager._internal();
//   List<String> responses = [];
//
//   factory GlobalResponseManager() {
//     return _instance;
//   }
//
//   GlobalResponseManager._internal();
//
//   void addResponse(String response) {
//     responses.add(response);
//   }
//
//   List<String> getResponses() {
//     return responses;
//   }
// }
//
// class DrugInfoDetail {
//   final String? name;
//   final String? enterpriseName;
//   final String? proOrGeneral;
//   final String? permitDate;
//   final String? chart;
//   final String? material;
//   final String? storageMethod;
//   final String? validTerm;
//   final DetailSection? efficacyEffect;
//   final DetailSection? dosageUsage;
//   final DetailSection? cautionGeneral;
//   final DetailSection? cautionProfessional;
//   final List<String>? warningInfo;
//
//   DrugInfoDetail({
//     this.name,
//     this.enterpriseName,
//     this.proOrGeneral,
//     this.permitDate,
//     this.chart,
//     this.material,
//     this.storageMethod,
//     this.validTerm,
//     this.efficacyEffect,
//     this.dosageUsage,
//     this.cautionGeneral,
//     this.cautionProfessional,
//     this.warningInfo,
//   });
//
//   factory DrugInfoDetail.fromJson(Map<String, dynamic> json) {
//     return DrugInfoDetail(
//       name: json['name'] as String?,
//       enterpriseName: json['enterpriseName'] as String?,
//       proOrGeneral: json['proOrGeneral'] as String?,
//       permitDate: json['permitDate'] as String?,
//       chart: json['chart'] as String?,
//       material: json['material'] as String?,
//       storageMethod: json['storageMethod'] as String?,
//       validTerm: json['validTerm'] as String?,
//       efficacyEffect: json['efficacyEffect'] != null ? DetailSection.fromJson(json['efficacyEffect']) : null,
//       dosageUsage: json['dosageUsage'] != null ? DetailSection.fromJson(json['dosageUsage']) : null,
//       cautionGeneral: json['cautionGeneral'] != null ? DetailSection.fromJson(json['cautionGeneral']) : null,
//       cautionProfessional: json['cautionProfessional'] != null ? DetailSection.fromJson(json['cautionProfessional']) : null,
//       warningInfo: (json['warningInfo'] as List<dynamic>?)?.map((e) => e as String).toList(),
//     );
//   }
//   static String removeHtmlTags(String htmlString) {
//     final document = parse(htmlString);
//     final String parsedString = parse(document.body?.text).documentElement?.text ?? '';
//     return parsedString;
//   }
// }
//
// class DetailSection {
//   final String? title;
//   final List<DetailSection>? sectionList;
//   final List<Article>? articleList;
//
//   DetailSection({this.title, this.sectionList, this.articleList});
//
//   factory DetailSection.fromJson(Map<String, dynamic> json) {
//     return DetailSection(
//       title: json['title'] as String?,
//       sectionList: (json['sectionList'] as List<dynamic>?)
//           ?.map((e) => DetailSection.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       articleList: (json['articleList'] as List<dynamic>?)
//           ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }
//
// class Article {
//   final String? title;
//   final List<Paragraph>? paragraphList;
//
//   Article({this.title, this.paragraphList});
//
//   factory Article.fromJson(Map<String, dynamic> json) {
//     return Article(
//       title: json['title'] as String?,
//       paragraphList: (json['paragraphList'] as List<dynamic>?)
//           ?.map((e) => Paragraph.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }
//
// class Paragraph {
//   final String? description;
//
//   Paragraph({this.description});
//
//   factory Paragraph.fromJson(Map<String, dynamic> json) {
//     return Paragraph(
//       description: json['description'] != null
//           ? DrugInfoDetail.removeHtmlTags(json['description'])
//           : null,
//     );
//   }
// }
//
// class DrugInfo {
//   final int serialNumber;
//   final String name;
//   final String classification;
//   final String enterprise;
//   final String imgUrl;
//   bool isBookmarked;
//
//   DrugInfo(
//       {required this.serialNumber,
//       required this.name,
//       required this.classification,
//       required this.enterprise,
//       required this.imgUrl,
//       required this.isBookmarked});
//
//   factory DrugInfo.fromJson(Map<String, dynamic> json) {
//     return DrugInfo(
//       serialNumber: json['serialNumber'],
//       name: json['name'],
//       classification: json['classification'],
//       enterprise: json['enterprise'],
//       imgUrl: json['imgUrl'],
//       isBookmarked: false,
//     );
//   }
// }
//
// class DrugsManager {
//   static final DrugsManager _instance = DrugsManager._internal();
//
//   List<DrugInfo> drugs = [];
//
//   factory DrugsManager() {
//     return _instance;
//   }
//
//   DrugsManager._internal();
//
//   void updateDrugs(String jsonResponse) {
//     final data = jsonDecode(jsonResponse)['result'] as List;
//     drugs = data.map((json) => DrugInfo.fromJson(json)).toList();
//   }
// }
//
// class TakingDrugsInfo {
//   final int serialNumber;
//   final String name;
//   final String classification;
//   final String enterprise;
//   final String imgUrl;
//   bool isBookmarked;
//
//   TakingDrugsInfo({
//     required this.serialNumber,
//     required this.name,
//     required this.classification,
//     required this.enterprise,
//     required this.imgUrl,
//     required this.isBookmarked,
//   });
//
//   factory TakingDrugsInfo.fromJson(Map<String, dynamic> json) {
//     return TakingDrugsInfo(
//       serialNumber: json['serialNumber'],
//       name: json['name'],
//       classification: json['classification'],
//       enterprise: json['enterprise'],
//       imgUrl: json['imgUrl'],
//       isBookmarked: false,
//     );
//   }
// }
//
// class TakingDrugsManager {
//   static final TakingDrugsManager _instance = TakingDrugsManager._internal();
//
//   List<TakingDrugsInfo> drugs = [];
//
//   factory TakingDrugsManager() {
//     return _instance;
//   }
//
//   TakingDrugsManager._internal();
//
//   void updateDrugs(String jsonResponse) {
//     final decoded = jsonDecode(jsonResponse);
//     if (decoded != null && decoded['pillInfoList'] != null) {
//       final data = decoded['pillInfoList'] as List;
//       drugs = data.map((json) => TakingDrugsInfo.fromJson(json)).toList();
//     } else {
//       drugs = [];
//     }
//   }
// }
//
//
// class FavoriteInfo {
//   final int serialNumber;
//   final String name;
//   final String classification;
//   final String enterprise;
//   final String imgUrl;
//   bool isBookmarked;
//
//   FavoriteInfo(
//       {required this.serialNumber,
//         required this.name,
//         required this.classification,
//         required this.enterprise,
//         required this.imgUrl,
//         required this.isBookmarked});
//
//   factory FavoriteInfo.fromJson(Map<String, dynamic> json) {
//     return FavoriteInfo(
//       serialNumber: json['serialNumber'],
//       name: json['name'],
//       classification: json['classification'],
//       enterprise: json['enterprise'],
//       imgUrl: json['imgUrl'],
//       isBookmarked: true,
//     );
//   }
// }
//
// class FavoritesManager {
//   static final FavoritesManager _instance = FavoritesManager._internal();
//
//   List<FavoriteInfo> favorites = [];
//
//   factory FavoritesManager() {
//     return _instance;
//   }
//
//   FavoritesManager._internal();
//
//   void updateFavorites(String jsonResponse) {
//     final data = jsonDecode(jsonResponse)['favoriteList'] as List;
//     favorites = data.map((json) => FavoriteInfo.fromJson(json)).toList();
//   }
// }
//
// class RecentHistoryInfo {
//   final int serialNumber;
//   final String name;
//   final String classification;
//   final String enterprise;
//   final String imgUrl;
//
//   RecentHistoryInfo(
//       {required this.serialNumber,
//         required this.name,
//         required this.classification,
//         required this.enterprise,
//         required this.imgUrl});
//
//   factory RecentHistoryInfo.fromJson(Map<String, dynamic> json) {
//     return RecentHistoryInfo(
//       serialNumber: json['serialNumber'],
//       name: json['name'],
//       classification: json['classification'],
//       enterprise: json['enterprise'],
//       imgUrl: json['imgUrl'],
//     );
//   }
// }
//
// class RecentHistoriesManager {
//   static final RecentHistoriesManager _instance = RecentHistoriesManager._internal();
//
//   List<RecentHistoryInfo> recentHistories = [];
//
//   factory RecentHistoriesManager() {
//     return _instance;
//   }
//
//   RecentHistoriesManager._internal();
//
//   void updateFavorites(String jsonResponse) {
//     final data = jsonDecode(jsonResponse)['result'] as List;
//     recentHistories = data.map((json) => RecentHistoryInfo.fromJson(json)).toList();
//   }
// }
//
// class Profile {
//   final String id;
//   final String name;
//   final String? imgURL; // imgURL을 nullable로 변경
//   final String color;
//
//   Profile({
//     required this.id,
//     required this.name,
//     this.imgURL, // nullable 처리
//     required this.color,
//     required String email,
//   });
//
//   factory Profile.fromJson(Map<String, dynamic> json) {
//     return Profile(
//       id: json['id'],
//       name: json['name'],
//       imgURL: json['imgURL'] ?? '', // imgURL이 null일 경우 빈 문자열로 처리
//       color: json['color'],
//       email: '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'imgURL': imgURL,
//       'color': color,
//     };
//   }
// }
//
//
//
// class ProfileResponse {
//   final List<Profile> profileList;
//
//   ProfileResponse({required this.profileList});
//
//   factory ProfileResponse.fromJson(Map<String, dynamic> json) {
//     var list = json['profileList'] as List;
//     List<Profile> profileList = list.map((i) => Profile.fromJson(i)).toList();
//     return ProfileResponse(profileList: profileList);
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'profileList': profileList.map((profile) => profile.toJson()).toList(),
//     };
//   }
// }
//
// class Category {
//   final String categoryId;
//   final String name;
//
//   Category({required this.categoryId, required this.name});
//
//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       categoryId: json['categoryId'],
//       name: json['name'],
//     );
//   }
// }
//
// class CategoryManager {
//   static final CategoryManager _instance = CategoryManager._internal();
//
//   List<Category> categories = [];
//
//   factory CategoryManager() {
//     return _instance;
//   }
//
//   CategoryManager._internal();
//
//   void updateCategories(String jsonResponse) {
//     final data = jsonDecode(jsonResponse)['categoryList'] as List;
//     categories = data.map((json) => Category.fromJson(json)).toList();
//   }
// }
//
// class CategoryDetails {
//   String id;
//   String name;
//   bool alarm;
//   DateTime period;
//   List<String> intakeDayList;
//   List<String> intakeTimeList;
//
//   CategoryDetails({
//     required this.id,
//     required this.name,
//     required this.alarm,
//     required this.period,
//     required this.intakeDayList,
//     required this.intakeTimeList,
//   });
//
//   factory CategoryDetails.fromJson(Map<String, dynamic> json) {
//     return CategoryDetails(
//       id: json['id'] as String,
//       name: json['name'] as String,
//       alarm: json['alarm'] as bool,
//       period: DateTime(json['period'][0], json['period'][1], json['period'][2]),
//       intakeDayList: List<String>.from(json['intakeDayList']),
//       intakeTimeList: List<String>.from(json['intakeTimeList']),
//     );
//   }
// }
//
// class CategoryDetailsManager {
//   static final CategoryDetailsManager _instance = CategoryDetailsManager._internal();
//
//   CategoryDetails? currentCategory;
//   Map<String, CategoryDetails> categoryDetailsMap = {};
//
//   factory CategoryDetailsManager() {
//     return _instance;
//   }
//
//   CategoryDetailsManager._internal();
//
//   void updateCategoryDetails(String jsonResponse) {
//     final data = jsonDecode(jsonResponse);
//     final categoryDetails = CategoryDetails.fromJson(data);
//     currentCategory = categoryDetails;
//     categoryDetailsMap[categoryDetails.id] = categoryDetails; // Map 업데이트
//   }
//
//   CategoryDetails? getCategoryDetails(String categoryId) {
//     return categoryDetailsMap[categoryId];
//   }
// }
//
//
//
// class MemberInfo {
//   final String id;
//   final String name;
//   final String email;
//   final String? imgURL;
//   final String color;
//
//   MemberInfo({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.imgURL,
//     required this.color,
//   });
//
//   factory MemberInfo.fromJson(Map<String, dynamic> json) {
//     return MemberInfo(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       imgURL: json['imgURL'],
//       color: json['color'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'imgURL': imgURL,
//       'color': color,
//     };
//   }
// }

class GlobalResponseManager {
  static final GlobalResponseManager _instance = GlobalResponseManager._internal();
  List<String> responses = [];

  factory GlobalResponseManager() {
    return _instance;
  }

  GlobalResponseManager._internal();

  void addResponse(String response) {
    responses.add(response);
  }

  List<String> getResponses() {
    return responses;
  }
}
