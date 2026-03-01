import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:leaguestats_mobile/core/interfaces/league_interface.dart';
import 'package:leaguestats_mobile/core/models/leagues/league_list_response_dto.dart';
import 'package:http/http.dart' as http;

class LeagueService implements LeagueInterface {
  String get _apiUrl {
    final host =
        kIsWeb || defaultTargetPlatform != TargetPlatform.android
        ? 'localhost'
        : '10.0.2.2';
    return 'http://$host:8000/api';
  }

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
}