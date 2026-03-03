part of 'league_bloc.dart';

abstract class LeagueEvent {}

class LoadLeaguesEvent extends LeagueEvent {}

final class LoadLeagueIdEvent extends LeagueEvent {
  final int id;

  LoadLeagueIdEvent({required this.id});
}

final class LoadLeagueTeamsEvent extends LeagueEvent {
  final int idTeam;

  LoadLeagueTeamsEvent({required this.idTeam});
}
