import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sopf_front/services/services_api_client.dart';

class PharmacyService extends APIClient {
  Future<void> pharmacyAroundGet(BuildContext context, String longitude, String latitude) async {
    final response = await get(Uri.parse('${APIClient.baseUrl}/app/pharmacy/around?longitude=$longitude&latitude=$latitude&distance=1000.0'));

    if (response.statusCode == 200) {
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('주변 약국 조회 성공: $jsonResponse');
    } else {
      print(response.statusCode);
      print('주변 약국 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}
