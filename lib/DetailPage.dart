import 'package:flutter/material.dart';

class PillDetailPage extends StatelessWidget {
  const PillDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DetailPage(),
      ),
    );
  }
}


class DetailPage extends StatelessWidget {
  // 예시 데이터 - 실제 앱에서는 서버나 로컬 데이터베이스에서 데이터를 불러와야 함
  final String productName = "제품명";
  final String productPhotoUrl = "assets/pill.png"; // 알약 사진 경로
  final String usage = " - ";
  final String precautions = " - ";
  final String warnings = " - ";
  final String efficacy = " - ";
  final String sideEffects = " - ";
  final String storageMethod = " - ";
  final String productCategoryAndManufacturer = " - ";

  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: Text('알약 세부 정보'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
          width: 393,
          height: 852,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              _buildHeaderSection(productName),
              _buildImageSection(productPhotoUrl),
              _buildInfoSection('사용 방법', usage),
              _buildInfoSection('사용 시 주의 사항', precautions),
              _buildInfoSection('주의 사항', warnings),
              _buildInfoSection('효능', efficacy),
              _buildInfoSection('부작용', sideEffects),
              _buildInfoSection('보관 방법', storageMethod),
              _buildInfoSection('제품 분류명 및 제조 회사', productCategoryAndManufacturer),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildImageSection(String imageUrl) {
    return Container(
      width: 370,
      height: 200,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Image.asset(imageUrl, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: 370,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 5),
            Text(
              content,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
