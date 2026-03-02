import 'dart:convert';

import 'package:leaguestats_mobile/core/interfaces/bet_interface.dart';
import 'package:leaguestats_mobile/core/models/bets/bet_response_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/place_bet_request_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/user_bet_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:http/http.dart' as http;

class BetService implements BetInterface {
  final String _apiBaseUrl = 'http://10.0.2.2:8000/api';
  final StorageService storageService = StorageService();
  @override
  Future<List<BetResponseDto>> getActiveBets() async {
    var token = await storageService.getToken();

    var response = await http.get(
      Uri.parse('$_apiBaseUrl/bets/active'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var betsList = BetResponseDto.fromJsonList(jsonDecode(response.body));
        return betsList;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<BetResponseDto>> getUserBets(int id) async {
    final token = await storageService.getToken();
    final response = await http.get(
      Uri.parse('$_apiBaseUrl/userBets/$id/bets'), // Ajusta a tu ruta real
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Devuelve la lista de apuestas
    } else {
      throw Exception("Error al obtener historial: ${response.body}");
    }
  }

  @override
  Future<void> bet(PlaceBetRequestDto dto) async {
    var token = await storageService.getToken();

    var response = await http.post(
      Uri.parse('$_apiBaseUrl/userBets'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );

    print('DTO: $dto');

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> checkAlreadyBetAmount(int betId) async {
    var token = await storageService.getToken();

    try {
      var response = await http.get(
        Uri.parse('$_apiBaseUrl/userBets/check/$betId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {
          'amount': double.parse(data['total_bet'].toString()).toInt(),
          'winner_selected':
              data['winner_selected'], // Añadimos el equipo elegido
        };
      }
      return {'amount': 0, 'winner_selected': null};
    } catch (e) {
      return {'amount': 0, 'winner_selected': null};
    }
  }

  @override
  Future<void> withdrawBet(int betId) async {
    var token = await storageService.getToken();

    var response = await http.post(
      Uri.parse(
        '$_apiBaseUrl/userBets/withdraw/$betId',
      ), // El ID va directo en la URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return; // Éxito
      } else {
        throw Exception("Error al retirar: ${response.body}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  // En bet_service.dart

  Future<List<UserBetDto>> getUserBetsById(int userId) async {
    final token = await storageService.getToken();
    final url = '$_apiBaseUrl/userBets/$userId/bets';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Decodificamos el JSON (que es una lista)
      final List<dynamic> data = jsonDecode(response.body);

      // Convertimos cada elemento de la lista en un objeto UserBetDto
      return data.map((json) => UserBetDto.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener apuestas: ${response.statusCode}");
    }
  }
}
