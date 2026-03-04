import 'package:leaguestats_mobile/core/interfaces/game_interface.dart';
import 'package:leaguestats_mobile/core/models/games/game_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:leaguestats_mobile/core/utils/safe_json_decode.dart';
import 'package:http/http.dart' as http;

class GamesService implements GameInterface {
  final String _apiUrl = 'http://10.0.2.2:8000/api';
  final StorageService storageService = StorageService();

  Map<String, dynamic> _extractGameMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final candidates = [decoded['data'], decoded['game'], decoded['result']];

      for (final candidate in candidates) {
        if (candidate is Map<String, dynamic>) {
          return candidate;
        }
      }

      return decoded;
    }

    throw Exception('Formato de respuesta inválido para game');
  }

  List<dynamic> _extractGamesList(dynamic decoded) {
    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      final candidates = [decoded['data'], decoded['games'], decoded['result']];

      for (final candidate in candidates) {
        if (candidate is List) {
          return candidate;
        }
      }
    }

    return const [];
  }

  @override
  Future<List<GameResponseDto>> getAll() async {
    var token = await storageService.getToken();
    var response = await http.get(
      Uri.parse('$_apiUrl/games'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<dynamic> gamesPayload = const [];

        try {
          final decoded = safeJsonDecode(response.body);
          gamesPayload = _extractGamesList(decoded);

          if (gamesPayload.isEmpty && decoded is Map<String, dynamic>) {
            return [GameResponseDto.fromJson(decoded)];
          }
        } catch (_) {
          gamesPayload = safeExtractJsonObjects(response.body);
        }

        if (gamesPayload.isEmpty) {
          gamesPayload = safeExtractJsonObjects(response.body);
        }

        final games = GameResponseDto.fromJsonList(gamesPayload);

        if (games.isEmpty) {
          throw Exception('No se pudieron parsear partidas válidas');
        }

        return games;
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GameResponseDto> getBydId(int id) async {
    var token = await storageService.getToken();
    var response = await http.get(
      Uri.parse('$_apiUrl/games/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = safeJsonDecode(response.body);
        final gameMap = _extractGameMap(decoded);
        var game = GameResponseDto.fromJson(gameMap);
        return game;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
