part of 'user_page_bloc.dart';

@immutable
sealed class UserPageState {}

final class UserPageInitial extends UserPageState {}

final class UserPageLoading extends UserPageState {}

final class UserPageSuccess extends UserPageState {
  final UserResponseDto dto;

  UserPageSuccess({required this.dto});
}

final class UserPageError extends UserPageState {
  final String message;

  UserPageError({required this.message});
}
