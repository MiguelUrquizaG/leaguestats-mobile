import 'package:bloc/bloc.dart';
import 'package:leaguestats_mobile/core/models/games/game_response_dto.dart';
import 'package:leaguestats_mobile/core/services/games_service.dart';
import 'package:meta/meta.dart';

part 'games_page_event.dart';
part 'games_page_state.dart';

class GamesPageBloc extends Bloc<GamesPageEvent, GamesPageState> {
  GamesPageBloc(GamesService gameService) : super(GamesPageInitial()) {
    on<GetAllEvent>((event, emit) async {
      emit(GamesPageLoading());

      try {
        var games = await gameService.getAll();
        emit(GamesPageSuccess(dto: games));
      } catch (e) {
        emit(GamesPageError(message: e.toString()));
      }
    });
  }
}
