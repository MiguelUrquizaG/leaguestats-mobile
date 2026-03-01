import 'dart:convert';

import 'package:leaguestats_mobile/core/interfaces/country_interface.dart';
import 'package:leaguestats_mobile/core/models/countries/country_list_response_dto.dart';
import 'package:http/http.dart' as http;

class CountryService implements CountryInterface {
  final String _apiUrl = 'http://10.0.2.2:8000/api';
  @override
  Future<List<CountryListResponseDto>> getAll() async {
    final response = await http.get(
      Uri.parse('${_apiUrl}/countries'),
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded
              .map(
                (item) => CountryListResponseDto.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList();
        }

        if (decoded is Map<String, dynamic>) {
          return [CountryListResponseDto.fromJson(decoded)];
        }

        throw Exception('Formato de respuesta inválido para countries');
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
