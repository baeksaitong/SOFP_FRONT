import 'package:flutter/material.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Search History',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: SearchHistoryScreen(),
//     );
//   }
// }

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({Key? key}) : super(key: key);

  @override
  _SearchHistoryScreenState createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchHistory = [
    'test',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 330,
              height: 48,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 3, color: Color(0xFF53DACA)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '검색어를 입력하세요',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: _search,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _search(_searchController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _clearSearchHistory();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: searchHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(searchHistory[index]),
            trailing: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _removeFromSearchHistory(index);
              },
            ),
            onTap: () {
              // 검색어를 선택했을 때 수행할 동작
              _showSearchResult(context, searchHistory[index]);
            },
          );
        },
      ),
    );
  }

  void _search(String value) {
    _addToSearchHistory(value);
    _searchController.clear();
  }

  void _addToSearchHistory(String value) {
    setState(() {
      searchHistory.insert(0, value);
    });
  }

  void _clearSearchHistory() {
    setState(() {
      searchHistory.clear();
    });
  }

  void _removeFromSearchHistory(int index) {
    setState(() {
      searchHistory.removeAt(index);
    });
  }

  void _showSearchResult(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(query: query),
      ),
    );
  }
}

class SearchResultScreen extends StatelessWidget {
  final String query;

  const SearchResultScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Result for "$query"'),
      ),
      body: Center(
        child: Text(
          'Search result will be displayed here for "$query".',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
