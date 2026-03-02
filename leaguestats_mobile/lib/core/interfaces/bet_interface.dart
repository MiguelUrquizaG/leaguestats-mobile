import 'package:leaguestats_mobile/core/models/bets/bet_response_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/place_bet_request_dto.dart';

abstract class BetInterface {
  Future<List<BetResponseDto>> getActiveBets();
  Future<List<BetResponseDto>> getUserBets();
  Future<void> bet(PlaceBetRequestDto dto);
  Future<int> checkAlreadyBetAmount(int betId);
  Future<void> withdrawBet(int betId);
}
