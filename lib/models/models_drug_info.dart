class DrugInfo {
  final int serialNumber;
  final String name;
  final String classification;
  final String enterprise;
  final String imgUrl;
  bool isBookmarked;

  DrugInfo({
    required this.serialNumber,
    required this.name,
    required this.classification,
    required this.enterprise,
    required this.imgUrl,
    required this.isBookmarked,
  });

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
