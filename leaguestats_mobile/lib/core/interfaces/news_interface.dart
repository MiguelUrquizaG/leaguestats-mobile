import 'package:leaguestats_mobile/core/models/news/comment_request_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_comment_response_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_list_response_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_response_dto.dart';

abstract class NewsInterface {
  Future<List<NewsResponseDto>> getAll();
  Future<NewsResponseDto>getById(int id);
  Future<List<NewsCommentResponseDto>>getNewsComments(int id);
  Future<void>postComment(CommentRequestDto dto, int idNews);
  Future<void>updateComment(CommentRequestDto dto,int idNews);
  Future<List<NewsCommentResponseDto>>findCommentsUserNew(int idNews);
  Future<void>deleteComment(int idNews);
  // Future<void>likeComment(int idNews);
}
