part of 'team_bloc.dart';

abstract class TeamState {}

class TeamInitial extends TeamState {}

class TeamLoading extends TeamState {}

class TeamLoaded extends TeamState {
  TeamLoaded({required this.teams});

  final List<TeamListResponseDto> teams;
}

class SingleTeamLoaded extends TeamState {
  final TeamListResponseDto dto;

  SingleTeamLoaded({required this.dto});
}

class TeamError extends TeamState {
  TeamError({required this.message});
  
  final String message;
}
