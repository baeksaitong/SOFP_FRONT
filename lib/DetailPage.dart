import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  // 예시 데이터 - 실제 앱에서는 서버나 로컬 데이터베이스에서 데이터를 불러와야 함
  final String productName = "제품명";
  final String productPhotoUrl = "assets/your_photo.png"; // 알약 사진 경로
  final String usage = "사용 방법";
  final String precautions = "사용 시 주의 사항";
  final String warnings = "주의 사항";
  final String efficacy = "효능";
  final String sideEffects = "부작용";
  final String storageMethod = "보관 방법";
  final String productCategoryAndManufacturer = "제품 분류명 및 제조 회사";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('세부 정보'),
      ),
      body: SingleChildScrollView(
        child: Container(
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
      padding: const EdgeInsets.only(top: 20, bottom: 20),
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
        child: Image.asset(imageUrl, fit: BoxFit.cover), // 실제 앱에서는 NetworkImage를 사용할 수도 있습니다.
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
