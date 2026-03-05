import 'package:leaguestats_mobile/core/models/news/news_response_dto.dart';

class NewsListResponse {
  final List<NewsResponseDto> results;

  NewsListResponse({
    required this.results,
  });

  factory NewsListResponse.fromJson(Map<String, dynamic> json) {
    return NewsListResponse(
  
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