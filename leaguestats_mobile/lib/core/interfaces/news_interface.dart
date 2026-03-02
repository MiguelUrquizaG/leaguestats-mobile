import 'package:leaguestats_mobile/core/models/news/news_list_response_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_response_dto.dart';

abstract class NewsInterface {
  Future<List<NewsResponseDto>> getAll();
  Future<NewsResponseDto>getById(int id);
}
