part of 'news_page_bloc.dart';

@immutable
sealed class NewsPageEvent {}

final class NewsGetAllEvent extends NewsPageEvent {}

final class NewsGetById extends NewsPageEvent {
  final int id;

  NewsGetById({required this.id});
}
