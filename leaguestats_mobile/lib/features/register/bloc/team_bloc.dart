import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';
import 'package:leaguestats_mobile/core/services/team_service.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  TeamBloc(this._teamService) : super(TeamInitial()) {
    on<LoadTeamsEvent>((event, emit) async {
      emit(TeamLoading());
      try {
        final teams = await _teamService.getAll();
        emit(TeamLoaded(teams: teams));
      } catch (e) {
        emit(TeamError(message: e.toString()));
      }
    });
  }

  final TeamService _teamService;
}
