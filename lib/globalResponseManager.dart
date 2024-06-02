import 'dart:convert';
import 'package:html/parser.dart' show parse;

class GlobalResponseManager {
  static final GlobalResponseManager _instance =
      GlobalResponseManager._internal();
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

class DrugInfoDetail {
  final String? name;
  final String? enterpriseName;
  final String? proOrGeneral;
  final String? permitDate;
  final String? chart;
  final String? material;
  final String? storageMethod;
  final String? validTerm;
  final DetailSection? efficacyEffect;
  final DetailSection? dosageUsage;
  final DetailSection? cautionGeneral;
  final DetailSection? cautionProfessional;
  final List<String>? warningInfo;

  DrugInfoDetail({
    this.name,
    this.enterpriseName,
    this.proOrGeneral,
    this.permitDate,
    this.chart,
    this.material,
    this.storageMethod,
    this.validTerm,
    this.efficacyEffect,
    this.dosageUsage,
    this.cautionGeneral,
    this.cautionProfessional,
    this.warningInfo,
  });

  factory DrugInfoDetail.fromJson(Map<String, dynamic> json) {
    return DrugInfoDetail(
      name: json['name'] as String?,
      enterpriseName: json['enterpriseName'] as String?,
      proOrGeneral: json['proOrGeneral'] as String?,
      permitDate: json['permitDate'] as String?,
      chart: json['chart'] as String?,
      material: json['material'] as String?,
      storageMethod: json['storageMethod'] as String?,
      validTerm: json['validTerm'] as String?,
      efficacyEffect: json['efficacyEffect'] != null ? DetailSection.fromJson(json['efficacyEffect']) : null,
      dosageUsage: json['dosageUsage'] != null ? DetailSection.fromJson(json['dosageUsage']) : null,
      cautionGeneral: json['cautionGeneral'] != null ? DetailSection.fromJson(json['cautionGeneral']) : null,
      cautionProfessional: json['cautionProfessional'] != null ? DetailSection.fromJson(json['cautionProfessional']) : null,
      warningInfo: (json['warningInfo'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }
  static String removeHtmlTags(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body?.text).documentElement?.text ?? '';
    return parsedString;
  }
}

class DetailSection {
  final String? title;
  final List<DetailSection>? sectionList;
  final List<Article>? articleList;

  DetailSection({this.title, this.sectionList, this.articleList});

  factory DetailSection.fromJson(Map<String, dynamic> json) {
    return DetailSection(
      title: json['title'] as String?,
      sectionList: (json['sectionList'] as List<dynamic>?)
          ?.map((e) => DetailSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      articleList: (json['articleList'] as List<dynamic>?)
          ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Article {
  final String? title;
  final List<Paragraph>? paragraphList;

  Article({this.title, this.paragraphList});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String?,
      paragraphList: (json['paragraphList'] as List<dynamic>?)
          ?.map((e) => Paragraph.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Paragraph {
  final String? description;

  Paragraph({this.description});

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    return Paragraph(
      description: json['description'] != null
          ? DrugInfoDetail.removeHtmlTags(json['description'])
          : null,
    );
  }
}




class DrugInfo {
  final int serialNumber;
  final String name;
  final String classification;
  final String enterprise;
  final String imgUrl;
  bool isBookmarked;

  DrugInfo(
      {required this.serialNumber,
      required this.name,
      required this.classification,
      required this.enterprise,
      required this.imgUrl,
      required this.isBookmarked});

  factory DrugInfo.fromJson(Map<String, dynamic> json) {
    return DrugInfo(
      serialNumber: json['serialNumber'],
      name: json['name'],
      classification: json['classification'],
      enterprise: json['enterprise'],
      imgUrl: json['imgUrl'],
      isBookmarked: false,
    );
  }
}

class DrugsManager {
  static final DrugsManager _instance = DrugsManager._internal();

  List<DrugInfo> drugs = [];

  factory DrugsManager() {
    return _instance;
  }

  DrugsManager._internal();

  void updateDrugs(String jsonResponse) {
    final data = jsonDecode(jsonResponse)['result'] as List;
    drugs = data.map((json) => DrugInfo.fromJson(json)).toList();
  }
}

class FavoriteInfo {
  final int serialNumber;
  final String name;
  final String classification;
  final String enterprise;
  final String imgUrl;
  bool isBookmarked;

  FavoriteInfo(
      {required this.serialNumber,
        required this.name,
        required this.classification,
        required this.enterprise,
        required this.imgUrl,
        required this.isBookmarked});

  factory FavoriteInfo.fromJson(Map<String, dynamic> json) {
    return FavoriteInfo(
      serialNumber: json['serialNumber'],
      name: json['name'],
      classification: json['classification'],
      enterprise: json['enterprise'],
      imgUrl: json['imgUrl'],
      isBookmarked: true,
    );
  }
}

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();

  List<FavoriteInfo> favorites = [];

  factory FavoritesManager() {
    return _instance;
  }

  FavoritesManager._internal();

  void updateFavorites(String jsonResponse) {
    final data = jsonDecode(jsonResponse)['favoriteList'] as List;
    favorites = data.map((json) => FavoriteInfo.fromJson(json)).toList();
  }
}

class RecentHistoryInfo {
  final int serialNumber;
  final String name;
  final String classification;
  final String enterprise;
  final String imgUrl;

  RecentHistoryInfo(
      {required this.serialNumber,
        required this.name,
        required this.classification,
        required this.enterprise,
        required this.imgUrl});

  factory RecentHistoryInfo.fromJson(Map<String, dynamic> json) {
    return RecentHistoryInfo(
      serialNumber: json['serialNumber'],
      name: json['name'],
      classification: json['classification'],
      enterprise: json['enterprise'],
      imgUrl: json['imgUrl'],
    );
  }
}

class RecentHistoriesManager {
  static final RecentHistoriesManager _instance = RecentHistoriesManager._internal();

  List<RecentHistoryInfo> recentHistories = [];

  factory RecentHistoriesManager() {
    return _instance;
  }

  RecentHistoriesManager._internal();

  void updateFavorites(String jsonResponse) {
    final data = jsonDecode(jsonResponse)['result'] as List;
    recentHistories = data.map((json) => RecentHistoryInfo.fromJson(json)).toList();
  }
}

class Profile {
  final String id;
  final String name;
  final String? imgURL;
  final String color;

  Profile({
    required this.id,
    required this.name,
    this.imgURL,
    required this.color,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      imgURL: json['imgURL'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imgURL': imgURL,
      'color': color,
    };
  }
}

class ProfileResponse {
  final List<Profile> profileList;

  ProfileResponse({required this.profileList});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    var list = json['profileList'] as List;
    List<Profile> profileList = list.map((i) => Profile.fromJson(i)).toList();
    return ProfileResponse(profileList: profileList);
  }

  Map<String, dynamic> toJson() {
    return {
      'profileList': profileList.map((profile) => profile.toJson()).toList(),
    };
  }
}
