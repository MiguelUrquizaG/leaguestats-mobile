part of 'login_page_bloc.dart';

@immutable
sealed class LoginPageState {}

final class LoginPageInitial extends LoginPageState {}

final class LoginPageLoading extends LoginPageState {}

final class LoginPageSuccess extends LoginPageState {
  final LoginResponseDto dto;

  LoginPageSuccess({required this.dto});
}

final class LoginPageError extends LoginPageState {
  final String message;

  LoginPageError({required this.message});
}
