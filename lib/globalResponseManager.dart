import 'dart:convert';
//import 'dart:ffi';

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
  final String? efficacyEffect;
  final String? dosageUsage;
  final String? cautionGeneral;
  final String? cautionProfessional;
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
      efficacyEffect: json['efficacyEffect'] as String?,
      dosageUsage: json['dosageUsage'] as String?,
      cautionGeneral: json['cautionGeneral'] as String?,
      cautionProfessional: json['cautionProfessional'] as String?,
      warningInfo: (json['warningInfo'] as List<dynamic>?)?.map((e) => e as String).toList(),
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
