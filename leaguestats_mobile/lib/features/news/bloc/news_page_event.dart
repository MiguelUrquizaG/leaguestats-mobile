part of 'news_page_bloc.dart';

@immutable
sealed class NewsPageEvent {}

final class NewsGetAllEvent extends NewsPageEvent {}

final class NewsGetById extends NewsPageEvent {
  final int id;

  NewsGetById({required this.id});
}

final class NewsGetComments extends NewsPageEvent {
  final int id;

  NewsGetComments({required this.id});
}

final class NewsPostComment extends NewsPageEvent {
  final CommentRequestDto dto;
  final int idNews;

  NewsPostComment({required this.dto, required this.idNews});
}

final class NewsEditComment extends NewsPageEvent {
  final CommentRequestDto dto;
  final int idNews;

  NewsEditComment({required this.dto, required this.idNews});
}

final class GetCommentsUserNews extends NewsPageEvent {
  final int idNews;

  GetCommentsUserNews({required this.idNews});
}

final class DeleteCommentUser extends NewsPageEvent {
  final int idNews;

  DeleteCommentUser({required this.idNews});
}

final class LikeCommentUser extends NewsPageEvent {
  final int idNews;

  LikeCommentUser({required this.idNews});
}

final class UnlikeCommentUser extends NewsPageEvent {
  final int idNews;

  UnlikeCommentUser({required this.idNews});
}
