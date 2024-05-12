import 'package:flutter/material.dart';
import 'package:sopf_front/searchResult.dart';
import 'package:sopf_front/textSearch.dart';

import 'main.dart';

void navigateToTextSearchDetail() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => TextSearchDetail()),
  );
}

void navigateToSearchResult() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => SearchResult()),
  );
}