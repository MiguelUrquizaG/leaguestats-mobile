part of 'player_page_bloc.dart';

@immutable
sealed class PlayerPageState {}

final class PlayerPageInitial extends PlayerPageState {}

final class PlayerPageLoading extends PlayerPageState {}

final class PlayerPageSuccess extends PlayerPageState {
  final PlayerResponseDto dto;

  PlayerPageSuccess({required this.dto});
}

final class PlayerPageError extends PlayerPageState {
  final String message;

  PlayerPageError({required this.message});
}
