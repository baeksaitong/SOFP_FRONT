class DrugInfo {
  final String pillId;
  final int serialNumber;
  final String name;
  final String classification;
  final String enterprise;
  final String imgUrl;
  bool isBookmarked;
  final String shape;
  final String color;
  // final String formulation;
  final String line;

  DrugInfo({
    required this.pillId,
    required this.serialNumber,
    required this.name,
    required this.classification,
    required this.enterprise,
    required this.imgUrl,
    required this.isBookmarked,
    required this.shape,
    required this.color,
    // required this.formulation,
    required this.line
  });

  factory DrugInfo.fromJson(Map<String, dynamic> json) {
    return DrugInfo(
      pillId: json['pillId'],
      serialNumber: json['serialNumber'],
      name: json['name'],
      classification: json['classification'],
      enterprise: json['enterprise'],
      imgUrl: json['imgUrl'],
      isBookmarked: false,
      shape: json['filter']['shape'] as String? ?? 'Unknown', // `filter`의 `shape` 값 처리
      color: json['filter']['colorFront'] as String? ?? 'Unknown', // `filter`의 `colorFront` 값 처리
      // formulation: json['filter'] as String? ?? 'Unknown', // 약의 제형을 `chart` 필드에서 가져옴
      line: json['filter']['lineFront'] as String? ?? 'None', // `filter`의 `lineFront` 값 처리
    );
  }
}
