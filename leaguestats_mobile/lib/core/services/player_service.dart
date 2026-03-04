import 'dart:convert';

import 'package:leaguestats_mobile/core/interfaces/players_interface.dart';
import 'package:leaguestats_mobile/core/models/players/player_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:http/http.dart' as http;

class PlayerService implements PlayersInterface {
  final String _apiUrl = "http://10.0.2.2:8000/api";
  final StorageService storageService = StorageService();
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
        var player = PlayerResponseDto.fromJson(jsonDecode(response.body));
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
      if(response.statusCode>=200 && response.statusCode<300){
        var listPlayers = PlayerResponseDto.fromJsonList(jsonDecode(response.body));
        return listPlayers;
      }else{
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
