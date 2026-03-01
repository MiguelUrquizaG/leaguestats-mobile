import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:leaguestats_mobile/core/interfaces/team_interface.dart';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';

class TeamService implements TeamInterface {
	String get _apiUrl {
		final host =
				kIsWeb || defaultTargetPlatform != TargetPlatform.android
						? 'localhost'
						: '10.0.2.2';
		return 'http://$host:8000/api';
	}

	@override
	Future<List<TeamListResponseDto>> getAll() async {
		final response = await http.get(
			Uri.parse('$_apiUrl/teams'),
			headers: {'Content-Type': 'application/json'},
		);

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
					return teamsPayload
							.whereType<Map>()
							.map(
								(item) => TeamListResponseDto.fromJson(
									Map<String, dynamic>.from(item),
								),
							)
							.toList();
				}

				throw Exception('Formato de respuesta inválido para teams');
			} else {
				throw Exception('Error ${response.statusCode}: ${response.body}');
			}
		} catch (e) {
			throw Exception(e.toString());
		}
	}
}
