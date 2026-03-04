import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';
import 'package:leaguestats_mobile/core/services/team_service.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 600);

  TeamBloc(this._teamService) : super(TeamInitial()) {
    on<LoadTeamsEvent>((event, emit) async {
      emit(TeamLoading());
      
      int attemptCount = 0;
      Exception? lastError;
      
      while (attemptCount < _maxRetries) {
        attemptCount++;
        try {
          final teams = await _teamService.getAll();
          emit(TeamLoaded(teams: teams));
          return;
        } catch (e) {
          lastError = Exception(e);
          if (attemptCount < _maxRetries) {
            await Future.delayed(_retryDelay);
          }
        }
      }
      
      emit(TeamError(message: lastError?.toString() ?? 'Error cargando equipos'));
    });
    on<GetByIdEvent>((event, emit) async {
      emit(TeamLoading());
      try {
        var team = await _teamService.getById(event.id);
        emit(SingleTeamLoaded(dto: team));
      } catch (e) {
        emit(TeamError(message: e.toString()));
      }
    });
  }

  final TeamService _teamService;
}
