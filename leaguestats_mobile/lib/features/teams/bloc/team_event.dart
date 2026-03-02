part of 'team_bloc.dart';

abstract class TeamEvent {}

class LoadTeamsEvent extends TeamEvent {}

final class GetByIdEvent extends TeamEvent {
  final int id;

  GetByIdEvent({required this.id});
}
