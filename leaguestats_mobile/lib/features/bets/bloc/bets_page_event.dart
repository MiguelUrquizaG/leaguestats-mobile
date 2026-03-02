part of 'bets_page_bloc.dart';

@immutable
sealed class BetsPageEvent {}

final class BetsGetActiveEvent implements BetsPageEvent {}

final class BetsPlaceEvent implements BetsPageEvent {
  final PlaceBetRequestDto dto;

  BetsPlaceEvent({required this.dto});
}

final class LoadPreviousBetEvent extends BetsPageEvent {
  final int betId;
  LoadPreviousBetEvent({required this.betId});
}

final class WithdrawBetEvent extends BetsPageEvent {
  final int betId;
  WithdrawBetEvent({required this.betId});
}
