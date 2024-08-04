// Project imports:
import 'package:flutter/material.dart';

class CategoryDetails {
  final String id;
  final String name;
  final bool alarm;
  final DateTime period;
  final List<String> intakeDayList;
  final List<String> intakeTimeList;

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
