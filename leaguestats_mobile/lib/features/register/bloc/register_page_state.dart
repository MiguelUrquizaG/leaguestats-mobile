part of 'register_page_bloc.dart';

abstract class RegisterPageState {}

class RegisterPageInitial extends RegisterPageState {}
class RegisterPageLoading extends RegisterPageState {}
class RegisterPageSuccess extends RegisterPageState {}
class RegisterPageError extends RegisterPageState {
  final String message;
  RegisterPageError({required this.message});
}
