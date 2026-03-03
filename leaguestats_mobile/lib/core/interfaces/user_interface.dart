import 'package:leaguestats_mobile/core/models/user/user_response_dto.dart';

abstract class UserInterface {
	Future<UserResponseDto> getCurrentUserProfile();
	Future<String> getCurrentUserEmail();
	Future<UserResponseDto> getUserProfileByEmail(String email);
  Future<void>addBalance(double amount);
  Future<void> subscribeToPremium();
}