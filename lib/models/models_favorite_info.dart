class FavoriteInfo {
  final int serialNumber;
  final String name;
  final String classification;
  final String enterprise;
  final String imgUrl;
  bool isBookmarked;

  FavoriteInfo({
    required this.serialNumber,
    required this.name,
    required this.classification,
    required this.enterprise,
    required this.imgUrl,
    required this.isBookmarked,
  });

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
