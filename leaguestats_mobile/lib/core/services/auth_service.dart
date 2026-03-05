import 'dart:convert';

import 'package:leaguestats_mobile/core/interfaces/auth_interface.dart';
import 'package:leaguestats_mobile/core/models/auth/login_request_dto.dart';
import 'package:leaguestats_mobile/core/models/auth/login_response_dto.dart';
import 'package:http/http.dart' as http;
import 'package:leaguestats_mobile/core/models/auth/register_request_dto.dart';
import 'package:leaguestats_mobile/core/models/auth/register_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';

class AuthService implements AuthInterface {
  final String _apiUrl = "http://10.0.2.2:8000/api";
  final StorageService storageService = StorageService();

  String _extractErrorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] != null) {
          return decoded['message'].toString();
        }
        if (decoded['errors'] != null) {
          return decoded['errors'].toString();
        }
      }
    } catch (_) {}

    return response.body;
  }

  @override
  Future<LoginResponseDto> login(LoginRequestDto dto) async {
    final response = await http.post(
      Uri.parse('${_apiUrl}/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(dto.toJson()),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final loginResponse = LoginResponseDto.fromJson(
          jsonDecode(response.body),
        );
        return loginResponse;
      } else {
        String rawError = _extractErrorMessage(response);
        String finalErrorMessage = rawError;

        if (rawError.toLowerCase().contains('invalid credentials')) {
          finalErrorMessage = 'Correo o contraseña incorrectos.';
        }
        throw finalErrorMessage;
      }
    } catch (e) {
      throw e.toString().replaceAll('Exception: ', '').trim();
    }
  }

  @override
  Future<RegisterResponseDto> register(RegisterRequestDto dto) async {
    final response = await http.post(
      Uri.parse('${_apiUrl}/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(dto.toJson()),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final registerResponse = RegisterResponseDto.fromJson(
          jsonDecode(response.body),
        );
        return registerResponse;
      } else {
        String rawError = _extractErrorMessage(response);
        String finalErrorMessage = rawError;

        String lowerError = rawError.toLowerCase();

        if (lowerError.contains('taken') ||
            lowerError.contains('already exists') ||
            lowerError.contains('registrado') ||
            lowerError.contains('uso')) {
          finalErrorMessage =
              'Este correo electrónico ya está en uso. Por favor, utiliza otro.';
        }
        else if (lowerError.contains('8 characters') ||
            lowerError.contains('least 8') ||
            lowerError.contains('short') ||
            lowerError.contains('corta')) {
          finalErrorMessage =
              'La contraseña es muy corta. Debe tener al menos 8 caracteres.';
        }

        throw finalErrorMessage;
      }
    } catch (e) {
      throw e.toString().replaceAll('Exception: ', '').trim();
    }
  }

  @override
  Future<void> logout() async {
    var token = await storageService.getToken();
    var response = await http.post(
      Uri.parse('$_apiUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
