import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/core/interfaces/auth_interface.dart';
import 'package:leaguestats_mobile/core/models/login_request_dto.dart';
import 'package:leaguestats_mobile/core/models/login_response_dto.dart';
import 'package:http/http.dart' as http;

class AuthService implements AuthInterface {
  final String _apiUrl = "http://10.0.2.2:8000/api";

  @override
  Future<LoginResponseDto> login(LoginRequestDto dto) async {
    var response = await http.post(
      Uri.parse('${_apiUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var loginResponse = LoginResponseDto.fromJson(
          jsonDecode(response.body),
        );
        print('PASO');
        print(loginResponse);
        return loginResponse;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
