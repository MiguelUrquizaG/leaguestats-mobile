import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:leaguestats_mobile/core/interfaces/team_interface.dart';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';

class TeamService implements TeamInterface {
	final String _apiUrl = 'http://10.0.2.2:8000/api';

	@override
	Future<List<TeamListResponseDto>> getAll() async {
		final response = await http.get(
			Uri.parse('$_apiUrl/teams'),
			headers: {'Content-Type': 'application/json'},
		);

		try {
			if (response.statusCode >= 200 && response.statusCode <= 300) {
				final decoded = jsonDecode(response.body);

				if (decoded is List) {
					return decoded
							.map(
								(item) => TeamListResponseDto.fromJson(
									Map<String, dynamic>.from(item as Map),
								),
							)
							.toList();
				}

				if (decoded is Map<String, dynamic>) {
					return [TeamListResponseDto.fromJson(decoded)];
				}

				throw Exception('Formato de respuesta inválido para teams');
			} else {
				throw Exception(response.body);
			}
		} catch (e) {
			throw Exception(e.toString());
		}
	}
}
