class Category {
  final String categoryId;
  final String name;

  Category({required this.categoryId, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      name: json['name'],
    );
  }
}

class CategoryDetails {
  String id;
  String name;
  bool alarm;
  DateTime period;
  List<String> intakeDayList;
  List<String> intakeTimeList;

  CategoryDetails({
    required this.id,
    required this.name,
    required this.alarm,
    required this.period,
    required this.intakeDayList,
    required this.intakeTimeList,
  });

  factory CategoryDetails.fromJson(Map<String, dynamic> json) {
    return CategoryDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      alarm: json['alarm'] as bool,
      period: DateTime(json['period'][0], json['period'][1], json['period'][2]),
      intakeDayList: List<String>.from(json['intakeDayList']),
      intakeTimeList: List<String>.from(json['intakeTimeList']),
    );
  }
}
