import 'dart:convert';

import 'package:leaguestats_mobile/core/interfaces/bet_interface.dart';
import 'package:leaguestats_mobile/core/models/bets/bet_response_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/place_bet_request_dto.dart';
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
  Future<List<BetResponseDto>> getUserBets() async {
    // TODO: implement getUserBets
    throw UnimplementedError();
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
  Future<int> checkAlreadyBetAmount(int betId) async {
    var token = await storageService.getToken();

    try {
      var response = await http.get(
        Uri.parse('$_apiBaseUrl/userBets/check/$betId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Convertimos a int por si Laravel devuelve un String de la base de datos
        return double.parse(data['total_bet'].toString()).toInt();
      }
      return 0;
    } catch (e) {
      return 0; // Si hay error de red, asumimos que es 0 para no bloquear la UI
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
}
