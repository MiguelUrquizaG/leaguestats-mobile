part of 'league_bloc.dart';

abstract class LeagueState {}

class LeagueInitial extends LeagueState {}

class LeagueLoading extends LeagueState {}

class LeagueLoaded extends LeagueState {
  LeagueLoaded({required this.leagues});

  final List<LeagueListResponseDto> leagues;
}

class LeagueError extends LeagueState {
  LeagueError({required this.message});

  final String message;
}
