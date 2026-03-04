import 'package:leaguestats_mobile/core/interfaces/players_interface.dart';
import 'package:leaguestats_mobile/core/models/players/player_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:leaguestats_mobile/core/utils/safe_json_decode.dart';
import 'package:http/http.dart' as http;

class PlayerService implements PlayersInterface {
  final String _apiUrl = "http://10.0.2.2:8000/api";
  final StorageService storageService = StorageService();

  Map<String, dynamic> _extractPlayerMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final candidates = [
        decoded['data'],
        decoded['player'],
        decoded['result'],
      ];

      for (final candidate in candidates) {
        if (candidate is Map<String, dynamic>) {
          return candidate;
        }
      }

      return decoded;
    }

    throw Exception('Formato inválido para jugador');
  }

  List<dynamic> _extractPlayersList(dynamic decoded) {
    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      final candidates = [
        decoded['data'],
        decoded['players'],
        decoded['result'],
      ];

      for (final candidate in candidates) {
        if (candidate is List) {
          return candidate;
        }
      }
    }

    return const [];
  }

  @override
  Future<PlayerResponseDto> getById(int id) async {
    var token = await storageService.getToken();
    var response = await http.get(
      Uri.parse('$_apiUrl/players/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = safeJsonDecode(response.body);
        final playerMap = _extractPlayerMap(decoded);
        var player = PlayerResponseDto.fromJson(playerMap);
        return player;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<PlayerResponseDto>> getAll() async {
    var token = await storageService.getToken();
    var response = await http.get(
      Uri.parse('$_apiUrl/players'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<dynamic> playersPayload = const [];

        try {
          final decoded = safeJsonDecode(response.body);
          playersPayload = _extractPlayersList(decoded);
        } catch (_) {
          playersPayload = safeExtractJsonObjects(response.body);
        }

        if (playersPayload.isEmpty) {
          playersPayload = safeExtractJsonObjects(response.body);
        }

        var listPlayers = PlayerResponseDto.fromJsonList(playersPayload);

        if (listPlayers.isEmpty) {
          throw Exception('No se pudieron obtener jugadores válidos');
        }

        return listPlayers;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
