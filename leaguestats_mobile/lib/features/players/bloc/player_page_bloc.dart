import 'package:bloc/bloc.dart';
import 'package:leaguestats_mobile/core/models/players/player_response_dto.dart';
import 'package:leaguestats_mobile/core/services/player_service.dart';
import 'package:meta/meta.dart';

part 'player_page_event.dart';
part 'player_page_state.dart';

class PlayerPageBloc extends Bloc<PlayerPageEvent, PlayerPageState> {
  PlayerPageBloc(PlayerService playerService) : super(PlayerPageInitial()) {
    on<GetByIdEvent>((event, emit) async {
      emit(PlayerPageLoading());
      try {
        var player = await playerService.getById(event.id);
        emit(PlayerPageSuccess(dto: player));
      } catch (e) {
        emit(PlayerPageError(message: e.toString()));
      }
    });
  }
}
