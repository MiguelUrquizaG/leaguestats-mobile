import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leaguestats_mobile/core/interfaces/user_interface.dart';
import 'package:leaguestats_mobile/core/models/user/user_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';

class UserService implements UserInterface {
  final String _apiUrl = "http://10.0.2.2:8000/api";
  final StorageService _storageService = StorageService();

  String _extractErrorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] != null) return decoded['message'].toString();
        if (decoded['errors'] != null) return decoded['errors'].toString();
      }
    } catch (_) {}
    return response.body;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<String> getCurrentUserEmail() async {
    final response = await http.get(
      Uri.parse('$_apiUrl/user'),
      headers: await _getHeaders(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        return decoded['email'].toString();
      } else {
        throw Exception(_extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserResponseDto> getUserProfileByEmail(String email) async {
    final response = await http.get(
      Uri.parse('$_apiUrl/usersProfile/search/$email'),
      headers: await _getHeaders(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final userProfile = UserResponseDto.fromJson(jsonDecode(response.body));
        return userProfile;
      } else {
        throw Exception(_extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserResponseDto> getCurrentUserProfile() async {
    try {
      final email = await getCurrentUserEmail();
      return await getUserProfileByEmail(email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> addBalance(double amount) async {
    final token = await _storageService.getToken();

    await Future.delayed(const Duration(milliseconds: 1500));

    final response = await http.post(
      Uri.parse('$_apiUrl/usersProfile/deposit'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'amount': amount}),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        throw Exception("Error al añadir saldo: ${response.body}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> subscribeToPremium() async {
    final response = await http.post(
      Uri.parse('$_apiUrl/usersProfile/subscribe-premium'),
      headers: await _getHeaders(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        throw Exception(_extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
