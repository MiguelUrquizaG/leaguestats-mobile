part of 'login_page_bloc.dart';

@immutable
sealed class LoginPageEvent {}

final class LoginEvent implements LoginPageEvent{
  final LoginRequestDto dto;

  LoginEvent({required this.dto});
}
