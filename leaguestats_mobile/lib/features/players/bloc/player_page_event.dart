part of 'player_page_bloc.dart';

@immutable
sealed class PlayerPageEvent {}

final class GetByIdEvent extends PlayerPageEvent{
  final int id;

  GetByIdEvent({required this.id});
}

final class GetAllEvent extends PlayerPageEvent{}