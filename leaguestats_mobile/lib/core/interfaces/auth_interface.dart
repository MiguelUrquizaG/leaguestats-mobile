import 'package:leaguestats_mobile/core/models/auth/login_request_dto.dart';
import 'package:leaguestats_mobile/core/models/auth/login_response_dto.dart';
import 'package:leaguestats_mobile/core/models/auth/register_request_dto.dart';
import 'package:leaguestats_mobile/core/models/auth/register_response_dto.dart';

abstract class AuthInterface {
  Future<LoginResponseDto>login(LoginRequestDto dto);
  Future<RegisterResponseDto>register(RegisterRequestDto dto);
  Future<void>logout();
}