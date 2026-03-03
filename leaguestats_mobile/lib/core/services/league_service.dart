import 'dart:convert';

import 'package:leaguestats_mobile/core/interfaces/league_interface.dart';
import 'package:leaguestats_mobile/core/models/leagues/league_list_response_dto.dart';
import 'package:http/http.dart' as http;
import 'package:leaguestats_mobile/core/models/leagues/league_team_response_dto.dart';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';

class LeagueService implements LeagueInterface {
  final String _apiUrl = "http://10.0.2.2:8000/api";
  final StorageService storageService = StorageService();

  @override
  Future<List<LeagueListResponseDto>> getAll() async {
    final response = await http.get(
      Uri.parse('$_apiUrl/leagues'),
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        List<dynamic>? leaguesPayload;

        if (decoded is List) {
          leaguesPayload = decoded;
        } else if (decoded is Map<String, dynamic>) {
          if (decoded['data'] is List) {
            leaguesPayload = decoded['data'] as List<dynamic>;
          } else if (decoded['leagues'] is List) {
            leaguesPayload = decoded['leagues'] as List<dynamic>;
          } else {
            return [LeagueListResponseDto.fromJson(decoded)];
          }
        }

        if (leaguesPayload != null) {
          return leaguesPayload
              .whereType<Map>()
              .map(
                (item) => LeagueListResponseDto.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();
        }

        throw Exception('Formato de respuesta inválido para leagues');
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<LeagueListResponseDto> getById(int idTeam) async {
    var token = await storageService.getToken();
    var response = await http.get(
      Uri.parse('$_apiUrl/leagues/$idTeam'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var team = LeagueListResponseDto.fromJson(jsonDecode(response.body));
        return team;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<LeagueTeamResponseDto>> getLeagueTeams(int idTeam) async {
    var token = await storageService.getToken();
    var response = await http.get(
      Uri.parse('$_apiUrl/leagues/$idTeam/teams'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    try{
      if(response.statusCode>=200 && response.statusCode<300){
        var teams = LeagueTeamResponseDto.fromJsonList(jsonDecode(response.body));
        return teams;
      }else{  
        throw Exception(response.body);
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
}
