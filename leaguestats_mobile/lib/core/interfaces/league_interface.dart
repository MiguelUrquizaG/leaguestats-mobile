import 'package:leaguestats_mobile/core/models/leagues/league_list_response_dto.dart';

abstract class LeagueInterface {
  Future<List<LeagueListResponseDto>> getAll();
}