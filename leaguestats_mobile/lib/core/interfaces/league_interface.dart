import 'package:leaguestats_mobile/core/models/leagues/league_list_response_dto.dart';
import 'package:leaguestats_mobile/core/models/leagues/league_team_response_dto.dart';

abstract class LeagueInterface {
  Future<List<LeagueListResponseDto>> getAll();
  Future<LeagueListResponseDto> getById(int idTeam);
  Future<List<LeagueTeamResponseDto>> getLeagueTeams(int idTeam);
}
