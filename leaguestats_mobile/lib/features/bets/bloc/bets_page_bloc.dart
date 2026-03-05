import 'package:bloc/bloc.dart';
import 'package:leaguestats_mobile/core/models/bets/bet_response_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/place_bet_request_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/user_bet_dto.dart';
import 'package:leaguestats_mobile/core/services/bet_service.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:leaguestats_mobile/core/services/user_service.dart';
import 'package:meta/meta.dart';

part 'bets_page_event.dart';
part 'bets_page_state.dart';

class BetsPageBloc extends Bloc<BetsPageEvent, BetsPageState> {
  BetsPageBloc(BetService betService) : super(BetsPageInitial()) {
    on<BetsGetActiveEvent>((event, emit) async {
      emit(BetsPageLoading());

      try {
        var bets = await betService.getActiveBets();
        emit(BetsPageActiveSuccess(dto: bets));
      } catch (e) {
        emit(BetsPageError(message: e.toString()));
      }
    });
    on<BetsPlaceEvent>((event, emit) async {
      emit(BetsPageLoading());

      try {
        final storageService = StorageService();
        final userService = UserService();

        String? email = await storageService.getEmail();
        if (email == null) throw Exception("Usuario no logueado");

        var userProfile = await userService.getUserProfileByEmail(email);

        event.dto.userId = userProfile.id;

        await betService.bet(event.dto);

        emit(BetsPlaceSuccess());
      } catch (e) {
        emit(BetsPageError(message: e.toString()));
      }
    });

    on<LoadPreviousBetEvent>((event, emit) async {
      emit(BetsPageLoading());
      try {
        var data = await betService.checkAlreadyBetAmount(event.betId);

        emit(
          PreviousBetSuccess(
            amount: data['amount'],
            winnerSelected: data['winner_selected'], 
          ),
        );
      } catch (e) {
        emit(PreviousBetSuccess(amount: 0, winnerSelected: null));
      }
    });

    on<WithdrawBetEvent>((event, emit) async {
      emit(BetsPageLoading());
      try {
        await betService.withdrawBet(event.betId);
        emit(WithdrawBetSuccess());
      } catch (e) {
        emit(BetsPageError(message: e.toString()));
      }
    });

    on<LoadUserBetsHistoryEvent>((event, emit) async {
      emit(BetsPageLoading());
      try {
        final storageService = StorageService();
        final userService = UserService();

        String? email = await storageService.getEmail();
        if (email == null) throw Exception("No se encontró sesión activa");

        var userProfile = await userService.getUserProfileByEmail(email);

        final List<UserBetDto> bets = await betService.getUserBetsById(
          userProfile.id!,
        );

        emit(UserBetsHistorySuccess(bets: bets));
      } catch (e) {
        emit(BetsPageError(message: e.toString()));
      }
    });
  }
}
