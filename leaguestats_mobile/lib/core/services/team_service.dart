import 'package:http/http.dart' as http;
import 'package:leaguestats_mobile/core/interfaces/team_interface.dart';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:leaguestats_mobile/core/utils/safe_json_decode.dart';

class TeamService implements TeamInterface {
  final String _apiUrl = "http://10.0.2.2:8000/api";
  final StorageService storageService = StorageService();

  Map<String, dynamic> _extractTeamMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final candidates = [decoded['data'], decoded['team'], decoded['result']];

      for (final candidate in candidates) {
        if (candidate is Map<String, dynamic>) {
          return candidate;
        }
      }

      return decoded;
    }

    throw Exception('Formato de respuesta inválido para team');
  }

  @override
  Future<List<TeamListResponseDto>> getAll() async {
    final response = await http
        .get(
          Uri.parse('$_apiUrl/teams'),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(const Duration(seconds: 20));

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<dynamic> teamsPayload = const [];

        try {
          final decoded = safeJsonDecode(response.body);

          if (decoded is List) {
            teamsPayload = decoded;
          } else if (decoded is Map<String, dynamic>) {
            if (decoded['data'] is List) {
              teamsPayload = decoded['data'] as List<dynamic>;
            } else if (decoded['teams'] is List) {
              teamsPayload = decoded['teams'] as List<dynamic>;
            } else {
              return [TeamListResponseDto.fromJson(decoded)];
            }
          }
        } catch (_) {
          teamsPayload = safeExtractJsonObjects(response.body);
        }

        if (teamsPayload.isEmpty) {
          teamsPayload = safeExtractJsonObjects(response.body);
        }

        final teams = <TeamListResponseDto>[];

        for (final item in teamsPayload) {
          if (item is! Map) {
            continue;
          }

          try {
            teams.add(
              TeamListResponseDto.fromJson(Map<String, dynamic>.from(item)),
            );
          } catch (_) {
            continue;
          }
        }

        if (teams.isEmpty) {
          throw Exception('No se pudieron parsear equipos válidos');
        }

        return teams;
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<TeamListResponseDto> getById(int id) async {
    var token = await storageService.getToken();
    var response = await http.get(
      Uri.parse('$_apiUrl/teams/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = safeJsonDecode(response.body);
        final teamMap = _extractTeamMap(decoded);
        var team = TeamListResponseDto.fromJson(teamMap);
        return team;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
