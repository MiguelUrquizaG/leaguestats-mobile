part of 'logout_page_bloc.dart';

@immutable
sealed class LogoutPageEvent {}

final class DoLogoutPageEvent extends LogoutPageEvent{}