import 'dart:convert';

import 'package:leaguestats_mobile/core/interfaces/game_interface.dart';
import 'package:leaguestats_mobile/core/models/games/game_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:http/http.dart' as http;

class GamesService implements GameInterface {
  final String _apiUrl = 'http://10.0.2.2:8000/api';
  final StorageService storageService = StorageService();

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
        final decoded = jsonDecode(response.body);
        List<dynamic>? gamesPayload;

        if (decoded is List) {
          gamesPayload = decoded;
        } else if (decoded is Map<String, dynamic>) {
          if (decoded['data'] is List) {
            gamesPayload = decoded['data'] as List<dynamic>;
          } else if (decoded['games'] is List) {
            gamesPayload = decoded['games'] as List<dynamic>;
          } else {
            return [GameResponseDto.fromJson(decoded)];
          }
        }

        if (gamesPayload == null) {
          throw Exception('Formato de respuesta inválido para games');
        }

        return GameResponseDto.fromJsonList(gamesPayload);
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
      if(response.statusCode>=200 && response.statusCode<300){
        var game = GameResponseDto.fromJson(jsonDecode(response.body));
        return game;
      }else{
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
