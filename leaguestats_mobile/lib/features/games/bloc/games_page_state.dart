part of 'games_page_bloc.dart';

@immutable
sealed class GamesPageState {}

final class GamesPageInitial extends GamesPageState {}

final class GamesPageLoading extends GamesPageState {}

final class GamesPageSuccess extends GamesPageState {
  final List<GameResponseDto> dto;

  GamesPageSuccess({required this.dto});
}

final class GameSinglePageSuccess extends GamesPageState {
  final GameResponseDto dto;

  GameSinglePageSuccess({required this.dto});
}

final class GamesPageError extends GamesPageState {
  final String message;

  GamesPageError({required this.message});
}
