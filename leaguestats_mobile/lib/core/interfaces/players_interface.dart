import 'package:leaguestats_mobile/core/models/players/player_response_dto.dart';

abstract class PlayersInterface {

  Future<PlayerResponseDto>getById(int id);
}