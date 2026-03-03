import 'package:leaguestats_mobile/core/models/games/game_response_dto.dart';

abstract class GameInterface {
  Future<List<GameResponseDto>> getAll();
  Future<GameResponseDto> getBydId(int id);
}
