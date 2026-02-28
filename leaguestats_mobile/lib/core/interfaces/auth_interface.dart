import 'package:leaguestats_mobile/core/models/login_request_dto.dart';
import 'package:leaguestats_mobile/core/models/login_response_dto.dart';

abstract class AuthInterface {
  Future<LoginResponseDto>login(LoginRequestDto dto);
}