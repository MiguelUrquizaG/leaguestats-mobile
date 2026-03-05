part of 'bets_page_bloc.dart';

@immutable
sealed class BetsPageState {}

final class BetsPageInitial extends BetsPageState {}

final class BetsPageLoading extends BetsPageState {}

final class BetsPageActiveSuccess extends BetsPageState {
  final List<BetResponseDto> dto;

  BetsPageActiveSuccess({required this.dto});
}

final class BetsPlaceSuccess extends BetsPageState {}

final class PreviousBetSuccess extends BetsPageState {
  final int amount;
  final int? winnerSelected;
  PreviousBetSuccess({required this.amount, this.winnerSelected});
}

final class WithdrawBetSuccess extends BetsPageState {}


final class UserBetsHistorySuccess extends BetsPageState {
  final List<UserBetDto> bets; 
  UserBetsHistorySuccess({required this.bets});
}

final class BetsPageError extends BetsPageState {
  final String message;

  BetsPageError({required this.message});
}
