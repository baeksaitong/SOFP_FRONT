import 'package:flutter/material.dart';

class PillDetailPage extends StatelessWidget {
  const PillDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body: DetailPage(),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String productName = "제품명";
  final String productPhotoUrl = "assets/pill.png";
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
          title: Text('알약 세부 정보', style: TextStyle(color: Colors.black)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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

  BoxDecoration _infoBoxDecoration() => BoxDecoration(
    color: Color(0xFFFFFF), // Easily changeable background color
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.greenAccent, width: 3), // Easily changeable border color and width
  );

  Widget _buildHeaderSection(String title) => Padding(
    padding: const EdgeInsets.only(left: 0, top: 10, right:10, bottom: 10),
    child: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
  );

  Widget _buildImageSection(String imageUrl) => Container(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // 좌우 여백을 10으로 설정
    decoration: _infoBoxDecoration(),
    child: ClipRRect( // 이미지의 모서리를 둥글게 하고 싶다면, ClipRRect를 사용
      borderRadius: BorderRadius.circular(20), // 컨테이너와 동일한 BorderRadius를 사용
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover, //BoxFit.cover로 설정하여 이미지가 컨테이너를 꽉 채우도록 함
      ),
    ),
  );

  Widget _buildInfoSection(String title, String content) => Container(
    margin: EdgeInsets.only(left: 10, top: 10, right: 10), // 좌우 여백을 10으로 설정하여 일치시킴
    decoration: _infoBoxDecoration(), // Use decoration function
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // 컨텐츠를 가로로 늘림
        children: [
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          SizedBox(height: 5),
          Text(content, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
        ],
      ),
    ),
  );
}
