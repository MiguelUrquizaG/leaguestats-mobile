import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:leaguestats_mobile/core/interfaces/team_interface.dart';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';

class TeamService implements TeamInterface {
  final String _apiUrl = "http://10.0.2.2:8000/api";
  final StorageService storageService = StorageService();

  @override
  Future<List<TeamListResponseDto>> getAll() async {
    final response = await http.get(
      Uri.parse('$_apiUrl/teams'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 20));

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        List<dynamic>? teamsPayload;

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

        if (teamsPayload != null) {
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
        }

        throw Exception('Formato de respuesta inválido para teams');
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
        var team = TeamListResponseDto.fromJson(jsonDecode(response.body));
        return team;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
