import 'package:leaguestats_mobile/core/models/news/news_response_dto.dart';

class NewsListResponse {
  final List<NewsResponseDto> results;

  NewsListResponse({
    required this.results,
  });

  factory NewsListResponse.fromJson(Map<String, dynamic> json) {
    return NewsListResponse(
      // Busca la lista en 'results' o en 'data'. Si no hay nada, devuelve lista vacía.
      results: (json['results'] as List<dynamic>? ?? json['data'] as List<dynamic>? ?? [])
          .map((v) => NewsResponseDto.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((v) => v.toJson()).toList(),
    };
  }
}