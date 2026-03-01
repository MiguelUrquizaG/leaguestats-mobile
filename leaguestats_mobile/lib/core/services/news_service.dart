import 'dart:convert';

import 'package:leaguestats_mobile/core/interfaces/news_interface.dart';
import 'package:http/http.dart' as http;
import 'package:leaguestats_mobile/core/models/news/news_list_response_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';

class NewsService implements NewsInterface {
  final String _apiUrl = "http://10.0.2.2:8000/api";
  final StorageService storage_service = StorageService();
  @override
  Future<List<NewsResponseDto>> getAll() async {
    var _token = await storage_service.getToken();
    var response = await http.get(
      Uri.parse('$_apiUrl/news'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var newsList = NewsListResponse.fromJson(jsonDecode(response.body));
        return newsList.results;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
