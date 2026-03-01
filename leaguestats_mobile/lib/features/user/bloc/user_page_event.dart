part of 'user_page_bloc.dart';

@immutable
sealed class UserPageEvent {}

final class UserProfileByEmailEvent implements UserPageEvent{
  final String? email;

  UserProfileByEmailEvent({ this.email});
}
