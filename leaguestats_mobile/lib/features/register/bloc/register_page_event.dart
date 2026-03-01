part of 'register_page_bloc.dart';

abstract class RegisterPageEvent {}

class RegisterEvent extends RegisterPageEvent {
  final RegisterRequestDto dto;
  RegisterEvent({required this.dto});
}
