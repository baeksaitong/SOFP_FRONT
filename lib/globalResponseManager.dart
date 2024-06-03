import 'dart:convert';

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

class DrugInfo {
  final String serialNumber;
  final String name;
  final String classification;
  final String enterprise;
  final String imgUrl;
  bool isBookmarked;

  DrugInfo({required this.serialNumber, required this.name, required this.classification, required this.enterprise, required this.imgUrl, required this.isBookmarked});

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

class GlobalManager {
  static final GlobalManager _instance = GlobalManager._internal();

  List<DrugInfo> drugs = [];

  factory GlobalManager() {
    return _instance;
  }

  GlobalManager._internal();

  void updateDrugs(String jsonResponse) {
    final data = jsonDecode(jsonResponse)['result'] as List;
    drugs = data.map((json) => DrugInfo.fromJson(json)).toList();
  }
}

class Profile {
  final String id;
  final String name;
  final String? imgURL; // imgURL을 nullable로 변경
  final String color;

  Profile({
    required this.id,
    required this.name,
    this.imgURL, // nullable 처리
    required this.color,
    required String email,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      imgURL: json['imgURL'] ?? '', // imgURL이 null일 경우 빈 문자열로 처리
      color: json['color'],
      email: '',
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


class MemberInfo {
  final String id;
  final String name;
  final String email;
  final String? imgURL;
  final String color;

  MemberInfo({
    required this.id,
    required this.name,
    required this.email,
    this.imgURL,
    required this.color,
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json) {
    return MemberInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imgURL: json['imgURL'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imgURL': imgURL,
      'color': color,
    };
  }
}
