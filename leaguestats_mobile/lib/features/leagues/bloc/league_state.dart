part of 'league_bloc.dart';

abstract class LeagueState {}

class LeagueInitial extends LeagueState {}

class LeagueLoading extends LeagueState {}

class LeagueLoaded extends LeagueState {
  LeagueLoaded({required this.leagues});

  final List<LeagueListResponseDto> leagues;
}

final class SingleLeagueLoaded extends LeagueState {
  final LeagueListResponseDto dto;

  SingleLeagueLoaded({required this.dto});
}

final class LeagueTeamsLoaded extends LeagueState {
  final List<LeagueTeamResponseDto> dto;

  LeagueTeamsLoaded({required this.dto});
}

class LeagueError extends LeagueState {
  LeagueError({required this.message});

  final String message;
}
