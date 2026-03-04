import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/core/models/leagues/league_list_response_dto.dart';
import 'package:leaguestats_mobile/core/models/leagues/league_team_response_dto.dart';
import 'package:leaguestats_mobile/core/services/league_service.dart';

part 'league_event.dart';
part 'league_state.dart';

class LeagueBloc extends Bloc<LeagueEvent, LeagueState> {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 600);

  LeagueBloc(this._leagueService) : super(LeagueInitial()) {
    on<LoadLeaguesEvent>((event, emit) async {
      emit(LeagueLoading());
      
      int attemptCount = 0;
      Exception? lastError;
      
      while (attemptCount < _maxRetries) {
        attemptCount++;
        try {
          final leagues = await _leagueService.getAll();
          emit(LeagueLoaded(leagues: leagues));
          return;
        } catch (e) {
          lastError = Exception(e);
          if (attemptCount < _maxRetries) {
            await Future.delayed(_retryDelay);
          }
        }
      }
      
      emit(LeagueError(message: lastError?.toString() ?? 'Error cargando ligas'));
    });
    on<LoadLeagueIdEvent>((event, emit) async {
      emit(LeagueLoading());
      try {
        var league = await this._leagueService.getById(event.id);
        emit(SingleLeagueLoaded(dto: league));
      } catch (e) {
        emit(LeagueError(message: e.toString()));
      }
    });
    on<LoadLeagueTeamsEvent>((event, emit) async {
      emit(LeagueLoading());
      try {
        var teams = await this._leagueService.getLeagueTeams(event.idTeam);
        emit(LeagueTeamsLoaded(dto: teams));
      } catch (e) {
        emit(LeagueError(message: e.toString()));
      }
    });
  }

  final LeagueService _leagueService;
}
