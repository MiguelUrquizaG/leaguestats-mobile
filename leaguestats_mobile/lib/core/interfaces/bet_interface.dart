import 'package:leaguestats_mobile/core/models/bets/bet_response_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/place_bet_request_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/user_bet_dto.dart';

abstract class BetInterface {
  Future<List<BetResponseDto>> getActiveBets();
  // Future<List<BetResponseDto>> getUserBets(int id);
  Future<void> bet(PlaceBetRequestDto dto);
  Future<Map<String, dynamic>> checkAlreadyBetAmount(int betId);
  Future<void> withdrawBet(int betId);
  Future<List<UserBetDto>> getUserBetsById(int userId);
  
}
