part of 'games_page_bloc.dart';

@immutable
sealed class GamesPageEvent {}

final class GetAllEvent extends GamesPageEvent {}

final class GetByIdEvent extends GamesPageEvent {
  final int id;

  GetByIdEvent({required this.id});
}
