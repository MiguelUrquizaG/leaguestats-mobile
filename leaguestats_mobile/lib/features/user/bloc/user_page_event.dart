part of 'user_page_bloc.dart';

@immutable
sealed class UserPageEvent {}

final class UserProfileByEmailEvent extends UserPageEvent {
  // Cambiado 'implements' por 'extends'
  final String? email;
  UserProfileByEmailEvent({this.email});
}

final class UserAddBalanceEvent extends UserPageEvent {
  final double amount;
  UserAddBalanceEvent({required this.amount});
}
