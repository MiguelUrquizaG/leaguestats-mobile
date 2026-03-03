part of 'news_page_bloc.dart';

@immutable
sealed class NewsPageState {}

final class NewsPageInitial extends NewsPageState {}

final class NewsPageLoading extends NewsPageState {}

final class NewsCommentsLoading extends NewsPageState {}

final class CommentLoading extends NewsPageState {}

final class NewsPageSuccess extends NewsPageState {
  final List<NewsResponseDto> dto;

  NewsPageSuccess({required this.dto});
}

final class GetCommentsUserNewsSuccess extends NewsPageState {
  final List<NewsCommentResponseDto> dto;

  GetCommentsUserNewsSuccess({required this.dto});
}

final class NewsPageSingleSuccess extends NewsPageState {
  final NewsResponseDto dto;

  NewsPageSingleSuccess({required this.dto});
}

final class NewsCommentsSuccess extends NewsPageState {
  final List<NewsCommentResponseDto> dto;

  NewsCommentsSuccess({required this.dto});
}

final class NewsPageError extends NewsPageState {
  final String message;

  NewsPageError({required this.message});
}

final class CommentSuccess extends NewsPageState {}

final class NewsCommentsPageError extends NewsPageState {
  final String message;

  NewsCommentsPageError({required this.message});
}

final class CommentError extends NewsPageState {
  final String message;

  CommentError({required this.message});
}

