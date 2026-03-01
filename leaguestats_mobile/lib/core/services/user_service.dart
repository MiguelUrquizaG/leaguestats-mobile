import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:leaguestats_mobile/core/interfaces/user_interface.dart';
import 'package:leaguestats_mobile/core/models/user/user_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';

class UserService implements UserInterface {
	UserService([StorageService? storageService])
		: _storageService = storageService ?? StorageService();

	final StorageService _storageService;

	String get _apiUrl {
		final host =
				kIsWeb || defaultTargetPlatform != TargetPlatform.android
				? 'localhost'
				: '10.0.2.2';
		return 'http://$host:8000/api';
	}

	Future<Map<String, String>> _buildAuthHeaders() async {
		final token = await _storageService.getToken();

		if (token == null || token.isEmpty) {
			throw Exception('No hay token de sesión. Inicia sesión de nuevo.');
		}

		return {
			'Content-Type': 'application/json',
			'Accept': 'application/json',
			'Authorization': 'Bearer $token',
		};
	}

	String _extractErrorMessage(http.Response response) {
		try {
			final decoded = jsonDecode(response.body);
			if (decoded is Map<String, dynamic>) {
				if (decoded['message'] != null) {
					return decoded['message'].toString();
				}
				if (decoded['error'] != null) {
					return decoded['error'].toString();
				}
			}
		} catch (_) {}

		return response.body;
	}

	@override
	Future<String> getCurrentUserEmail() async {
		final headers = await _buildAuthHeaders();
		final response = await http.get(Uri.parse('$_apiUrl/user'), headers: headers);

		if (response.statusCode < 200 || response.statusCode >= 300) {
			throw Exception('Error ${response.statusCode}: ${_extractErrorMessage(response)}');
		}

		final decoded = jsonDecode(response.body);
		if (decoded is! Map<String, dynamic>) {
			throw Exception('Formato inválido de /user');
		}

		final email = decoded['email']?.toString();
		if (email == null || email.isEmpty) {
			throw Exception('El usuario autenticado no tiene email');
		}

		return email;
	}

	UserResponseDto _parseUserProfileResponse(dynamic decoded) {
		if (decoded is Map<String, dynamic>) {
			if (decoded['data'] is Map<String, dynamic>) {
				return UserResponseDto.fromJson(decoded['data'] as Map<String, dynamic>);
			}

			if (decoded['userProfile'] is Map<String, dynamic>) {
				return UserResponseDto.fromJson(
					decoded['userProfile'] as Map<String, dynamic>,
				);
			}

			return UserResponseDto.fromJson(decoded);
		}

		throw Exception('Formato inválido de usersProfile');
	}

	@override
	Future<UserResponseDto> getUserProfileByEmail(String email) async {
		final headers = await _buildAuthHeaders();

		final primaryUri = Uri.parse('$_apiUrl/usersProfile/search/email').replace(
			queryParameters: {'email': email},
		);

		http.Response response = await http.get(primaryUri, headers: headers);

		if (response.statusCode < 200 || response.statusCode >= 300) {
			final fallbackUri = Uri.parse(
				'$_apiUrl/usersProfile/search/${Uri.encodeComponent(email)}',
			);
			final fallback = await http.get(fallbackUri, headers: headers);

			if (fallback.statusCode < 200 || fallback.statusCode >= 300) {
				throw Exception(
					'Error ${fallback.statusCode}: ${_extractErrorMessage(fallback)}',
				);
			}

			response = fallback;
		}

		final decoded = jsonDecode(response.body);
		return _parseUserProfileResponse(decoded);
	}

	@override
	Future<UserResponseDto> getCurrentUserProfile() async {
		final email = await getCurrentUserEmail();
		return getUserProfileByEmail(email);
	}
}