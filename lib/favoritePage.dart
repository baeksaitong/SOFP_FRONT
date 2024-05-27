import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> favorites = [
      {
        'name': '가스디알정50밀리그램',
        'manufacturer': '일동제약',
        'category': '기타소화기관용약 | 일반 의약품',
        'image': 'assets/image.png'
      },
      // 추가 항목을 여기에 추가
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return ListTile(
            leading: Image.asset(favorite['image']!),
            title: Text(favorite['name']!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('제품명: ${favorite['name']}'),
                Text('제조회사: ${favorite['manufacturer']}'),
                Text('분류: ${favorite['category']}'),
              ],
            ),
            trailing: Icon(Icons.star, color: Colors.teal),
            isThreeLine: true,
            contentPadding: EdgeInsets.all(8.0),
          );
        },
      ),
    );
  }
}
