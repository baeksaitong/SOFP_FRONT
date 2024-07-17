class RecentHistoryInfo {
  final int serialNumber;
  final String name;
  final String classification;
  final String enterprise;
  final String imgUrl;

  RecentHistoryInfo({
    required this.serialNumber,
    required this.name,
    required this.classification,
    required this.enterprise,
    required this.imgUrl,
  });

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
