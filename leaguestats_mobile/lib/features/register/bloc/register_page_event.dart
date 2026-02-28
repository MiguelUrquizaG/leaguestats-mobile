part of 'register_page_bloc.dart';

abstract class RegisterPageEvent {}

class RegisterEvent extends RegisterPageEvent {
  final String email;
  final String password;
  RegisterEvent({required this.email, required this.password});
}
