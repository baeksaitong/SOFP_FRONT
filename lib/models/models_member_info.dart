class MemberInfo {
  final String email;
  final bool advertisement;

  MemberInfo({
    required this.email,
    required this.advertisement,
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json) {
    return MemberInfo(
      email: json['email'] ?? '',
      advertisement: json['advertisement'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'advertisement': advertisement,
    };
  }
}
