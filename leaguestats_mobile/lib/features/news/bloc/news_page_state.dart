part of 'news_page_bloc.dart';

@immutable
sealed class NewsPageState {}

final class NewsPageInitial extends NewsPageState {}

final class NewsPageLoading extends NewsPageState{}

final class NewsPageSuccess extends NewsPageState{
  final List<NewsResponseDto> dto;

  NewsPageSuccess({required this.dto});
}

final class NewsPageError extends NewsPageState{
  final String message;

  NewsPageError({required this.message});
}
