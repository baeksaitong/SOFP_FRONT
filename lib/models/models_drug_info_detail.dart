import 'package:html/parser.dart' show parse;

class DrugInfoDetail {
  final String? name;
  final String? enterpriseName;
  final String? proOrGeneral;
  final String? permitDate;
  final String? chart;
  final String? material;
  final String? storageMethod;
  final String? validTerm;
  final DetailSection? efficacyEffect;
  final DetailSection? dosageUsage;
  final DetailSection? cautionGeneral;
  final DetailSection? cautionProfessional;
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
      efficacyEffect: json['efficacyEffect'] != null ? DetailSection.fromJson(json['efficacyEffect']) : null,
      dosageUsage: json['dosageUsage'] != null ? DetailSection.fromJson(json['dosageUsage']) : null,
      cautionGeneral: json['cautionGeneral'] != null ? DetailSection.fromJson(json['cautionGeneral']) : null,
      cautionProfessional: json['cautionProfessional'] != null ? DetailSection.fromJson(json['cautionProfessional']) : null,
      warningInfo: (json['warningInfo'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  static String removeHtmlTags(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body?.text).documentElement?.text ?? '';
    return parsedString;
  }
}

class DetailSection {
  final String? title;
  final List<DetailSection>? sectionList;
  final List<Article>? articleList;

  DetailSection({this.title, this.sectionList, this.articleList});

  factory DetailSection.fromJson(Map<String, dynamic> json) {
    return DetailSection(
      title: json['title'] as String?,
      sectionList: (json['sectionList'] as List<dynamic>?)
          ?.map((e) => DetailSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      articleList: (json['articleList'] as List<dynamic>?)
          ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Article {
  final String? title;
  final List<Paragraph>? paragraphList;

  Article({this.title, this.paragraphList});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String?,
      paragraphList: (json['paragraphList'] as List<dynamic>?)
          ?.map((e) => Paragraph.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Paragraph {
  final String? description;

  Paragraph({this.description});

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    return Paragraph(
      description: json['description'] != null
          ? DrugInfoDetail.removeHtmlTags(json['description'])
          : null,
    );
  }
}
