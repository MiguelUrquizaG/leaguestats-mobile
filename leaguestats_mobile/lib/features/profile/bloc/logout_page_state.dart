part of 'logout_page_bloc.dart';

@immutable
sealed class LogoutPageState {}

final class LogoutPageInitial extends LogoutPageState {}

final class LogoutPageLoading extends LogoutPageState {}

final class LogoutPageSuccess extends LogoutPageState {}

final class LogoutPageError extends LogoutPageState {
  final String message;

  LogoutPageError({required this.message});
}
