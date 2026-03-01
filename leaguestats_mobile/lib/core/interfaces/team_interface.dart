import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';

abstract class TeamInterface {
	Future<List<TeamListResponseDto>> getAll();
}