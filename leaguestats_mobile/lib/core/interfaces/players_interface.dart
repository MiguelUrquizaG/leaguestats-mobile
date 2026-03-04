import 'package:leaguestats_mobile/core/models/players/player_response_dto.dart';

abstract class PlayersInterface {
  Future<List<PlayerResponseDto>>getAll();
  Future<PlayerResponseDto>getById(int id);
}