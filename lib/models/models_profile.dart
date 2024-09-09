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
    required String email,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      imgURL: json['imgURL'] ?? '',
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

class ProfileDetail {
  final String id;
  final String name;
  final String gender;
  final String color;
  final String? imgURL;
  final String birthday;  // String으로 변환된 생년월일

  ProfileDetail({
    required this.id,
    required this.name,
    required this.gender,
    required this.color,
    this.imgURL,
    required this.birthday,  // String으로 변환된 생년월일
  });

  factory ProfileDetail.fromJson(Map<String, dynamic> json) {
    List<dynamic> birthdayList = json['birthday'];
    String birthday = "${birthdayList[0]}-${birthdayList[1].toString().padLeft(2, '0')}-${birthdayList[2].toString().padLeft(2, '0')}";

    return ProfileDetail(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      color: json['color'],
      imgURL: json['imgURL'],
      birthday: birthday, // 변환된 생년월일
    );
  }
}
